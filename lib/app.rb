require 'rubygems'
require 'sinatra'

require_relative 'ess'

# 
set :views, settings.root + '/../views'

get '/' do
  erb :index
end

get '/ess' do
  cl = Chl.new
  cl.readCSVFile('x')  
  @so = cl.printParams
  erb :ess
end

get '/ess2' do
  ai = Ess.new(params[:gens].to_i)   
  ai.evolute('x')
  @so=ai.so
  cl = Chl.new
  cl.readCSVFile('x')  
  @so << cl.printSolution(ai.winner)
  erb :ess2
end
 

get '/e' do
  erb :essout
end

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


get '/f' do
  "<h1>Hello World</h1>"
end

get '/admin' do
  %{
    <h1>Admin Page</h1>
    <h2>This is the stuff of admins</h2>
  }
end



