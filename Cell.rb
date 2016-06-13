#Nilay Altun
#Okan Gul
#Idil Sukas


# Keeps all the variables for the cell object.
# We use cell object for every meadow grid to store hill, food and ant informations.
class Cell
    attr_accessor :hill, :food, :cellAnts, :cellName
    
    def initialize
        @hill = nil
        @food = 0
        @cellAnts = []
        @cellName = nil
    end
end