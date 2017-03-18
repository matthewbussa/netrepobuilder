require 'sinatra'
require 'sinatra/flash'

enable :sessions

require './appveyor.rb'

get '/' do
  return 'Hello World'
end

get '/repo/' do
  erb :repo_builder_form
end

post '/repo/' do
  repo_name = params[:repo_name]
  email = params[:email]

  if (!email.end_with?("pillartechnology.com"))
    flash[:error] = "Email is not accepted"
    redirect '/repo/'
  end

  app = AppVeyor.new(repo_name, email)
  response = app.setup_new_build
  result = response.code == "200" ? "successfully" : "not successfully"

  erb :index, :locals => {'repo_name' => repo_name, 'result' => result}
end
