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

  if (email.to_s.empty? || !email.end_with?("pillartechnology.com"))
    flash[:error] = "Email is not accepted"
    redirect '/repo/'
  end

  # app = AppVeyor.new(repo_name, email)
  # response = app.setup_new_build

  success = "Build was sent to AppVeyor Successfully.  An email will be sent once the build is finished"
  error = "Something went wrong"

  if (response.code == "200")
    flash[:success] = success
  else
    flash[:error] = error
  end

  redirect '/repo/'
end
