# 
#  Choice List
# 
#  items and their attributes from which a solution is sought.
# 


class Chl 

  @cutval
  @itemID = []           # name
  @itemValue = []        # benefit
  @itemWeight = []       # cost
  @itemTitle
  @totalcost
  @totalbene
  @totalqty
  @totalrows
  @penalty            

  attr_reader :sum_value
  #@sum_value
  @sum_weight

  attr_reader :beneTitle
  attr_reader :costTitle
  attr_reader :optionSize
  attr_reader :goal
  attr_accessor :max_weight
  attr_accessor :min_value


  def initialize 
    @itemTitle="item"
    @cutval=0.0;           # cutoff value
    @penalty = 3.0         # add this if sum exceeds maxweight in fitness function.
    @totalcost=0.0         # to set MAXCOST 
    @totalbene=0.0         # useful info
    @totalqty=0            # count of items 1 per each item
    @totalrows=0           # count of input file rows 
    @sum_weight = 0.0      # Total weight of a sgenome's selected options
    @sum_value = 0.0       # Total value of a sgenome's selected options
  end


  # Fitness Method
  # rank the value of an sgenome
  #
  def calcFitness(sgenome)
 
    #puts "calcFitness" 
    calcWeightAndValue(sgenome)

    if (@sum_weight > @max_weight)
      # penalize overweight solutions 
      @sum_value - (@penalty * (@sum_weight - @max_weight))
    else 
      @sum_value
    end

  end


  # Accumulate weight and value if option is selected.
  # arg is an sgenome
  def calcWeightAndValue(possible_solution)
  
    @sum_weight=0
    @sum_value=0
 
    (0...@optionSize).each do |idx|
      if possible_solution.m_Data[idx] 

        @sum_weight += @itemWeight[idx].to_f
        @sum_value  += @itemValue[idx].to_f

      end 
    end
  
  end


  # evaluate sgenome for win/lose
  #
  def isWinner(possible_solution, maxc, minben) 
 
    (0...@optionSize).each do |idx|
      calcWeightAndValue(possible_solution)

      if (@sum_weight <= maxc && @sum_value >= minben  )    
        return true
      end

    end 

    false

  end


  # if all of the items total to less than minben, no success possible 
  #
  def isImpossible(minben) 
  
    sum_value = @itemValue.inject(0){|sum,item| sum+item} 

    if (sum_value < minben)    
      true
    else
      false
    end
 
  end


  def getSumValue(sgenome) 
    #puts "getSumValue"
    calcWeightAndValue(sgenome);
    @sum_value
  end

  def getSumWeight(sgenome) 
    #puts "getSumWeight"
    calcWeightAndValue(sgenome);
    @sum_weight
  end


  # Load the input file, parse, store.
  #
  # result is boolean
  def readCSVFile(csvfilename='') 

    @title = "Fryes Bag-o-Value"
    @costTitle = "volume"
    @beneTitle = "value"


    @cutname = "total volume"
    @cutop = "<"

    @cutval = 1000
    csvitemID=['cellphone1','cellphone2','cpu1','cpu2','ram 1', 'ram 2', 'ram 3']
    csvitemValue=[199.99,155.99,75.50,123.45, 32.99, 26.26, 45.94 ]
    csvitemWeight=[100,99,23,22, 15,15,15]
    csvitemQtys=[10,25,20,20,15,15,10]

    #@cutval = 500
    #csvitemID=['cellphone1','cellphone2','cpu1','cpu2','ram 1', 'ram 2', 'ram 3']
    #csvitemValue=[199.99,155.99,75.50,123.45, 32.99, 26.26, 45.94 ]
    #csvitemWeight=[100,99,23,22, 15,15,15]
    #csvitemQtys=[1,5,2,2,5,5,3]


    @totalrows = csvitemID.size  # count of item rows

    # total number of discrete items 
    @totalqty = csvitemQtys.inject(0){|sum,item| sum+item}   
    @optionSize=@totalqty;

    @totalcost=0.0    # initialize
    @totalbene=0.0    # initialize

    @itemID=Array.new
    @itemValue=Array.new
    @itemWeight=Array.new
    @itemQtys=Array.new

    # create one array element for each option, not each item, eg item1 qty2 = 2 elements

    (0...@totalrows).each do |row| 
    
      # calculate the total cost and value
      @totalbene+=csvitemQtys[row]*csvitemValue[row]
      @totalcost+=csvitemQtys[row]*csvitemWeight[row]

      # multiply the quantities by the csv data to create the array data.
      (0...csvitemQtys[row]).each do | unit |

        @itemID << csvitemID[row]
        @itemValue << csvitemValue[row]
        @itemWeight << csvitemWeight[row]
        @itemQtys << 1

      end

    end

    (0...@itemID.size).each do |ix| 
      #puts "#{@itemID[ix]} #{@itemValue[ix]} #{@itemWeight[ix]} #{@itemQtys[ix]}"
    end


    if @cutop == '>'
       #MINIMUM_COST
       @goal = "minimum cost"
       @min_value=@cutval
       @max_weight=@totalcost
    end

    if @cutop == '<'
       #MAXIMUM_BENEFIT
       @goal = "maximum benefit"
       @max_weight=@cutval
       @min_value=1
    end


  end




  def printParams

    puts  "\n"

    #puts  "Input rows: " + @totalrows.to_s + "  Items in stock: " + @totalqty.to_s 
    puts  "Items in stock: " + @totalqty.to_s 
    puts sprintf("Total %s of all items in stock: %.2f \n" , @costTitle ,  @totalcost)
    puts sprintf("Total %s of all items in stock: %.2f \n" , @beneTitle ,  @totalbene)
    puts  "Goal: " + @goal + " with "  + @cutname + " " + @cutop + " " + @cutval.to_s
    puts  sprintf("Possible solutions: %d" ,(2**@totalqty))

    puts  "\n"

  end


  def printTally(winner, showonlyselected) 
    # count unique ids.   items should be sequenced by item id.
    # need to count all for a given item, then print a single item line.
    #
    (0...@optionSize).each do |bitidx|
       if (winner.m_Data[bitidx])  
         puts "#{@itemID[bitidx]} #{@itemValue[bitidx]} #{@itemWeight[bitidx]}"
       end
    end
  end


  def printSolution(winner)
 
    # titles
    puts sprintf("%s\n",@title)

    # column headings
    puts sprintf("%s,%s,%s",@itemTitle,@beneTitle,@costTitle)

    # print the winner
    printTally(winner, true)

    # totals
    m_Value=getSumValue(winner)
    m_Weight=getSumWeight(winner)
    puts sprintf("Solution totals: %s: %.2f, %s: %.2f ",@beneTitle, m_Value ,  @costTitle, m_Weight)

  end 


end

