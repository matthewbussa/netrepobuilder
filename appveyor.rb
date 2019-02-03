require 'json'
require 'net/http'
require 'net/https'
require 'json'
require 'uri'

class AppVeyor

  def initialize(project_url, build_path, email)
    @project_url = project_url
    @build_path = build_path.to_s.empty? ? '.' : build_path
    @email = email

    @api_token = ENV['APPVEYOR_API_KEY']
    @base_url = 'https://ci.appveyor.com/api'
    @header = {"Authorization" => "Bearer #{@api_token}",
                "Content-type" => "application/json"
              }
    @header_text = {
      "Authorization" => "Bearer #{@api_token}",
      "Content-type" => "plain/text"
    }

  end

  def add_project()
    project_url = @base_url + '/projects'
    uri = URI.parse(project_url)

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, @header)

    request.body = {"repositoryProvider" => "git",
      "repositoryName" => @project_url
    }.to_json

    response = https.request(request)
    response
  end

  def update_project(project_slug, account_name)
    project_url = @base_url + "/projects/#{account_name}/#{project_slug}/settings/yaml"
    uri = URI.parse(project_url)

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Put.new(uri.path, @header_text)
    request.body = File.read('appveyor_template.yml')
      .gsub!('<<EMAIL_IS_REPLACED_HERE>>', @email)
      .gsub!('<<BUILD_PATH_IS_REPLACED_HERE>>', @build_path)

    https.request(request)
  end

  def add_build(project_slug, account_name)
    uri = URI.parse(@base_url + '/builds')

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, @header)
    request.body = {
        'accountName' => account_name,
        'projectSlug' => project_slug,
        'branch' => 'master'
    }.to_json

    https.request(request)
  end

  def setup_new_build()
    project = add_project
    project_response = JSON.parse(project.body)
    slug = project_response["slug"]
    account_name = project_response["accountName"]

    update_project(slug, account_name)
    add_build(slug, account_name)
  end

end
