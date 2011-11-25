require 'rubygems'
require 'sinatra'

# 
set :views, settings.root + '/../views'

# rest-ful url
get '/hello/:name' do
  @name = params[:name] 
  erb :hello
end

# non rest-ful url
get '/hello' do
  @name = params[:name] 
  erb :hello
end


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


