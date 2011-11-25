require 'rubygems'
require 'sinatra'
#require 'erb'

class Anman < Sinatra::Application

  set :views, settings.root + '/../views'

  get '/' do
    #erb :index
    "<h1>Hello World</h1>"
  end


  get '/user/:username' do

    begin 

      @user = params[:username]
      @num_followers = followers.length
  

    end

  end

  post // do
    halt 500, 'Whoa. Sorry. No POSTs allowed.'
  end

end
