require 'sinatra'
require './appveyor.rb'

get '/' do
  return 'Hello World'
end

get '/repo/' do
  erb :repo_builder_form
end

post '/repo/' do
  repo_name = params[:repo_name]

  app = AppVeyor.new(repo_name)
  response = app.setup_new_build
  result = response.code == "200" ? "successfully" : "not successfully"

  erb :index, :locals => {'repo_name' => repo_name, 'result' => result}
end
