require 'sinatra'
require 'sinatra/flash'

enable :sessions

require './appveyor.rb'

get '/repo/' do
  erb :repo_builder_form
end

post '/repo/' do
  repo_name = params[:repo_name]
  email = params[:email]

  puts "Repo Name #{repo_name}"
  puts "Email #{email}"

  validation_error_message = validate(repo_name, email)

  if (!validation_error_message.empty?)
    flash[:error] = validation_error_message
    redirect '/repo/'
  end

  error = "Something went wrong"
  success = "Build was sent to AppVeyor Successfully.  An email will be sent once the build is finished"

  begin
    app = AppVeyor.new(repo_name, email)
    response = app.setup_new_build

    if (response.code == "200")
      flash[:success] = success
    else
      flash[:error] = error
    end

  rescue Exception => e
    logger.error "Error:  Repo Name:  #{repo_name} and email: #{email} " + e.message
    flash[:error] = error
  end

  redirect '/repo/'
end

def validate(repo_name, email)
  error_message = ""

  if (repo_name.to_s.empty?)
    error_message = "Repository Name is empty"
  elsif (!repo_name.include? '/' )
    error_message = "Invalid Repository Name"
  elsif (email.to_s.empty?)
    error_message = "Email is empty"
  elsif (!email.to_s.end_with? "pillartechnology.com" )
    error_message = "Email domain is not accepted"
  end

  error_message
end
