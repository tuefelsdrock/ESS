
load 'ess.rb'



#fn = 'dummy' # file name 
#arg2 = 20 # max number of generations, if not supplied as arg 2

ai = Ess.new(20)   
ai.evolute('x')
puts ai.so

if ai.winner 
  # map @winner to choicelist to show winning answer.
  choicelist = Chl.new
  choicelist.readCSVFile(fn)  # read in to get the list to map to the winner
  choicelist.printSolution(ai.winner)
end
 


