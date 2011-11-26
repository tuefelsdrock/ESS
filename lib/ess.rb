# 
# Ess = evolutionary solution system
#
#
# The goal of Ess is to attempt to find an optimal solution to exponential-time problems.
#
# it evolves a solution until no further progress or interruption occurs.
#
#
# chl (choice list) = the entire set of optional items from which a solution is sought.
# sgenome = one possible solution composed of one or more items from a choice list.
# culture = a population of sgenomes.
# generation = a culture at a specific point in time.
# epoch = a sequence of generations.
#

require_relative 'chl'
require_relative 'culture'

class Ess 

  @opts                      # options, a list of choices.
  @option_size               # number of options.
  @population_size           # number of sgenomes in a generation.  
  @max_mutation_rate         # mutation factor.
  @max_epochs                # epoch iterations. 
  @max_gens                  # generation iterations.
  @gen_num                   # generation number.
  @min_value                 # value must be at least this number.
  @max_weight                # cost cannot exceed this number.

  attr_reader :winner        # the winning solution. 
  attr_reader :so

  def initialize( mg ) 
    @max_gens=mg  
    @opts = Chl.new
    @population_size=60 
    @max_mutation_rate = 0.10  
    @max_epochs=5             
    @gen_num=1
  end

  # main evelutionary loop
  #
  def evolute( iFn ) 

    if (! @opts.readCSVFile(iFn)) 
      puts "Input file error.\n"
    end

    @opts.printParams                   # display the parameters
    @option_size=@opts.optionSize
    @min_value=@opts.min_value
    @max_weight=@opts.max_weight

    # test if minvalue  >  maxpossible
    if ( @opts.isImpossible(@min_value) ) 
      puts "min benefit " + @min_value + " higher than all possible items."
      return
    end

    # Create the population 
    #
    pop = Culture.new(@population_size,@option_size,@max_mutation_rate,@opts)  # create a population.

    strategy=0  # set the initial strategy
 
    # loop thru epochs 
    (0...@max_epochs).each do |ep|

      @so=sprintf("\nStarting epoch %s, using strategy %s.  Population size: %s sgenomes\n" ,ep,strategy,@population_size) 
      #puts sprintf("\nStarting epoch %s, using strategy %s.  Population size: %s sgenomes\n" ,ep,strategy,@population_size) 

      # raise the minimum acceptable value  
      @min_value=@opts.calcFitness(@winner)*1.23456  if @winner    

      # if a certain number of generations has passed, change strategy 
      case @gen_num
        when 0
          strategy=1  
          @max_mutation_rate = 0.2
        when 1
          strategy=2  
          @max_mutation_rate = 0.1
        when 2
          strategy=3  
          @max_mutation_rate = 0.05
      end
      
      # loop thru generations 
      while (!evalSolution(pop,@max_weight,@min_value)) do
 
        @gen_num=pop.m_Generation

        pop.m_MaxMutationRate=@max_mutation_rate
        pop.createNextGeneration   # create a new population based on the fittest of the last

        # exit if maxgens exceeded.
        if (@gen_num > @max_gens)
            puts "\nGeneration " + @gen_num.to_s + " reached in this epoch.\n\n"
            break
        end

      end

    end


  end  



  # print the sum weight/val of a single sgenome
  #
  def printAnSgenome(pop, sgenonum )

    sgenome = pop.get_sgenome(sgenonum) 

    puts sprintf("Gen: %3d Sol: %3d %s: %8.2f %s: %8.2f " ,pop.m_Generation , sgenonum ,  @opts.beneTitle , @opts.getSumValue(sgenome) ,  @opts.costTitle , @opts.getSumWeight(sgenome))

    # display the map of the sgenome: | = selected
    puts sgenome.m_Data.map { |c|  c ? '|' : '-' }.join

  end 



  # evaluate solution for presence of a winner
  #
  def evalSolution(pop, maxcost, minben)

    results=false  
    # scan culture for solution
    (0...pop.get_population_size).each do |sgenomidx|

        if ( @opts.isWinner(pop.get_sgenome(sgenomidx),maxcost,minben) )        
            # we have a winner!
            @winner = pop.get_sgenome(sgenomidx)               # save 
            printAnSgenome(pop,sgenomidx)                      # show 
            results=true
            break
        else
            results=false
        end

    end
    results

  end 




end 



