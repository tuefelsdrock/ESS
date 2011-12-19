
require_relative 'rpjwh'
require_relative 'sgenome'

# 
# a culture is a population
#
class Culture 
  

  attr_reader :m_CurrentSize
  attr_reader :m_Generation
  attr_accessor :m_MaxMutationRate     

  def get_population_size 
    @m_CurrentSize 
  end

  def get_sgenome(iref) 
    @sgenoms[iref] 
  end


  # create one generation of a population of sgenomes 
  # with a compliment (opposite) created for each sgenome.
  # The probability that each bit is true increases with 
  # each sgenome created.
  #
  def initialize(size, length, maxMutationRate, oparg)  

    @sgenoms = []          # the population, an array of sgenomes
    @m_CrossoverMask = []  # used to mutate during crossover via a probability function.
    @options=oparg      # to refer to choices when evaluating.
    @m_Length=length
    @m_MaxSize = size
    @m_CurrentSize = 0
    @m_Generation = 1
    @m_MaxMutationRate = maxMutationRate

    # create an array of sgenomes
    @sgenoms = Array.new
    (0...@m_MaxSize).each do |idx|
      @sgenoms << Sgenome.new(@m_Length, idx / @m_MaxSize.to_f)
    end

    # populate with a range of sgenomes of increasing probability
    (0...(@m_MaxSize/2)).each do |idx|
      temp     = Sgenome.new(@m_Length,  idx / @m_MaxSize.to_f)
      compTemp = Sgenome.new(@m_Length,  idx / @m_MaxSize.to_f)
      compTemp.complement(temp)
      merge(temp)
      merge(compTemp)
    end

    #@sgenoms.each { |s| puts s.m_Data.map { |c|  c ? '|' : '-' }.join }
  end



  # merge a new sgenome if it is better
  #
  def merge(new_sgenome)
  
    hidx=0

    # starting at the fittest end, scan until the new is more fit than the current selection
    (0...@m_CurrentSize).each do |idx|
       break if (new_sgenome.getFitness() > @sgenoms[idx].getFitness())
       hidx+=1
    end

    # shift elements 1 index to make space for new_sgenome
    # [start,length]
    #
    @sgenoms[hidx+1,@m_CurrentSize-hidx]=@sgenoms[hidx,@m_CurrentSize-hidx] if @m_CurrentSize-hidx > 0

    # insert the new sgen here
    @sgenoms[hidx] = new_sgenome

    # increment the current size
    @m_CurrentSize+=1

  end


  #select a parent based on parent's probability for parenthood
  def getparent

    selection = Rpjwh.rand0UpTo1()

    while (Rpjwh.flip(selection)) do
      selection = Rpjwh.rand0UpTo1()  
    end    
    
    @sgenoms[(selection * @m_MaxSize)]

  end


  #Replace a dysgenic sgenoms 
  def replace_sgenome(new_sgenome) 

    selection = Rpjwh.rand0UpTo1()

    while (Rpjwh.flip(selection)) do
      selection = Rpjwh.rand0UpTo1()  
    end 
    
    idx = @m_MaxSize - (selection * @m_MaxSize) - 1
  
    # shift elements 1 index to make space for new_sgenome
    # [start,length]
    #
    @sgenoms[idx,@m_CurrentSize-idx-1]=@sgenoms[idx+1,@m_CurrentSize-idx-1] if @m_CurrentSize-idx-1 > 0
  
    @m_CurrentSize-=1
    merge(new_sgenome)

  end


  # create 2 offspring and  replace 2 @sgenoms of the population
  def createNextGeneration

    #fetch a couple of good parents:
    parent1 = getparent
    parent2 = getparent
  
    #clone blank kids
    child1 = Sgenome.new(@m_Length,0.0)
    child2 = Sgenome.new(@m_Length,0.0)
 
    #inherit
    crossover(parent1, parent2, child1, child2,  calcSimilarityRatio(parent1, parent2)*@m_MaxMutationRate)

    #add new kids to population
    replace_sgenome(child1)
    replace_sgenome(child2)
    @m_Generation+=1

  end


  # create 2 new offspring using a crossover operator - created with the given probability
  #
  def crossover( parent1, parent2, child1,  child2, prob ) 

    @m_CrossoverMask = Array.new(@m_Length)
    (0...@m_Length).each do |idx|
      @m_CrossoverMask[idx] = Rpjwh.flip(0.5)     #50% probability bit set
    end 
    #puts "xxxxxxxxxxxx mask #{@m_CrossoverMask}"

    #inheirit genes
    (0...@m_Length).each do |idx|
      if (@m_CrossoverMask[idx])
        child1.m_Data[idx] = parent1.m_Data[idx]
        child2.m_Data[idx] = parent2.m_Data[idx]
      else
        child1.m_Data[idx] = parent2.m_Data[idx]
        child2.m_Data[idx] = parent1.m_Data[idx]
      end
    end

    child1.mutate(prob)

    child2.mutate(prob)
    child1.m_Fitness = @options.calcFitness(child1)
    child2.m_Fitness = @options.calcFitness(child2)

  end 


  # calc the difference between 2 sgenoms
  #
  def calcSimilarityRatio( sgenom1, sgenom2  ) 
    matchCount=0

    (0...@m_Length).each do |idx|
      if (sgenom1.m_Data[idx]==sgenom2.m_Data[idx])
        matchCount+=1
      end
    end
    matchCount / @m_Length.to_f

  end 



end
