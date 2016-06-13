#Nilay Altun
#Okan Gul
#Idil Sukas

class Ant
    
    attr_accessor :ant_type, :ant_locX, :ant_locY
    attr_reader  :family_name
    
    # Initialize an ant but location is unknown until after anthill location is selected ants location is then declared.
    def initialize(family_name)
        @ant_type = -1
        @ant_locX = nil
        @ant_locY = nil
        @family_name = family_name
        
    end #end initialize
    
    def move(ant_locX,ant_locY) #move to new location
        @ant_locX=ant_locX
        @ant_locY=ant_locY
    end #end move function

end