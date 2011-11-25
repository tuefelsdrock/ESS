require 'rubygems'
require 'sinatra'

# 
set :views, settings.root + '/../views'

get '/' do
  "<h1>Hello World</h1>"
end

get '/admin' do
  %{
    <h1>Admin Page</h1>
    <h2>This is the stuff of admins</h2>
  }
end

#    #erb :index
#  get '/user/:username' do
get '/y' do
  erb :index
end

get '/x' do
  begin 
    @user = params[:user]
    "#{@user}"
  end
end


