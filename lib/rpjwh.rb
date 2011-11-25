

 # number methods

class Rpjwh 


  # return a pseudo-random number from 0-almost 1 
  #
  def self.rand0UpTo1
        xrand = Random.new
        xrand.rand
  end


  # compare random to argument
  #
  def self.flip(prob)  
    #if rand <= prob  # bias towards non-sparseness
    if rand > prob   # bias towards sparseness
      true
    else
      false
    end
  end

end


