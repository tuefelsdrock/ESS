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
  @sum_weight

  attr_reader :beneTitle
  attr_reader :costTitle
  attr_reader :optionSize
  attr_reader :goal
  attr_accessor :max_weight
  attr_accessor :min_value
  attr_reader :so          # output
  attr_reader :io          # inventory output


  def initialize 
    @so=" "
    @io=" "
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
    calcWeightAndValue(sgenome);
    @sum_value
  end

  def getSumWeight(sgenome) 
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

    #@cutval = 500
    @cutval = 1000
    csvitemID=['cellphone1','cellphone2','cpu1','cpu2','ram 1', 'ram 2', 'ram 3']
    csvitemValue=[199.99,155.99,75.50,123.45, 32.99, 26.26, 45.94 ]
    csvitemWeight=[100,99,23,22, 15,15,15]
    csvitemQtys=[10,25,20,20,15,15,10]



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


  def printInventory
    csvitemID=['cellphone1','cellphone2','cpu1','cpu2','ram 1', 'ram 2', 'ram 3']
    csvitemValue=[199.99,155.99,75.50,123.45, 32.99, 26.26, 45.94 ]
    csvitemWeight=[100,99,23,22, 15,15,15]
    csvitemQtys=[10,25,20,20,15,15,10]

    (0...@csvitemID.size).each do |x|
      @io << sprintf("%10s %10s %10s %10s \n",  csvitemID[x], csvitemValue[x], csvitemWeight[x], csvitemQtys[x] )
    end

  end


  def printParams

    @so << "\nItems in stock: " + @totalqty.to_s  + "\n"
    @so << sprintf("Total %s of all items in stock: %.2f \n" , @costTitle ,  @totalcost)
    @so << sprintf("Total %s of all items in stock: %.2f \n" , @beneTitle ,  @totalbene)
    @so << sprintf("Possible solutions: %d" ,(2**@totalqty))
    @so << "\nGoal: " + @goal + " with "  + @cutname + " " + @cutop + " " + @cutval.to_s + "\n"

  end


  def printTally(winner, showonlyselected) 
    # count unique ids.   items should be sequenced by item id.
    # need to count all for a given item, then print a single item line.
    #
    (0...@optionSize).each do |bitidx|
       if (winner.m_Data[bitidx])  
         @so << "#{@itemID[bitidx]} #{@itemValue[bitidx]} #{@itemWeight[bitidx]} \n"
       end
    end
  end


  def printSolution(winner)
 
    # titles
    @so << sprintf("\n\n%s\n",@title)

    # column headings
    @so << sprintf("%s,%s,%s \n",@itemTitle,@beneTitle,@costTitle)

    # print the winner
    printTally(winner, true)

    # totals
    m_Value=getSumValue(winner)
    m_Weight=getSumWeight(winner)
    @so << sprintf("Solution totals: %s: %.2f, %s: %.2f \n",@beneTitle, m_Value ,  @costTitle, m_Weight)

  end 


end

