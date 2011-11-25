
#  each instance of an sgenome maps one possible solution.
#  each bit in the @m_Data array will be set to true if the corresponding option is selected.
#  This class is patterned as a 'Flyweight' because there may be a large number of these objects.


require_relative 'rpjwh'

class Sgenome 


  attr_accessor :m_Data         # Bitmap.  true = option at this index is selected.
  attr_accessor :m_Fitness

  @m_Length                     # Total number of all options.

 
  # create and set bits at the given probability.
  def initialize(length, prob) 
    
    @m_Fitness=0.0

    @m_Length = length
    @m_Data = Array.new(@m_Length,false)

    #iterate, populate with probabilities
    @m_Data.map! do |d| 
      d=Rpjwh.flip(prob)
    end

  end

  def getLength
    @m_Length
  end

  def getFitness
    @m_Fitness
  end 

  def setFitness(f) 
    @m_Fitness=f
  end

  def getbit(idx) 
    @m_Data[Idx]
  end


  # mutate this sgenome 
  #
  def mutate(prob) 

    @m_Data.map! do |d| 
      if Rpjwh.flip(prob)
        !d
      else
         d
      end
    end

  end


  # make an opposite to an sgenome. 
  #
  def complement( orig )   

    #clone
    @m_Data = orig.m_Data

    # flip the clone
    @m_Data.map! {|d| !d}


  end



end

