require 'rubygems'
require 'sinatra'

require_relative 'ess'

# 
set :views, settings.root + '/../views'
set :public_folder, settings.root + '/../public'

get '/' do
  erb :index
end

get '/ess' do
  cl = Chl.new
  cl.readCSVFile('x')  
  @io = cl.printInventory
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
 
get '/ess3' do
  erb :ess3
end




