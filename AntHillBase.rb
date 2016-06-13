#Nilay Altun
#Okan Gul
#Idil Sukas

class AntHillBase
    
    # Keeps all variables of the anthill.
    attr_accessor :ants, :food
    attr_reader :name, :loc_x, :loc_y
    attr_accessor :antsKills, :colonyKills
    
    def initialize(number_ants,name)
        @ants = []
        @name=name
        @queen=nil
        @antsKills = 0
        @colonyKills = 0
        @food=5
        @loc_x=nil
        @loc_y=nil
        
        number_ants.times do |i|
            ant = create_ant(name)
            @ants << ant
        end
        @food=0
    end #end initialize
    
    #Program output for every 5 rounds.
    def printHills
        
        puts ("AntHill Name:  " + @name)
        print("Ant Kills:  ")
        puts (@antsKills)
        print("Colony Kills:  ")
        puts (@colonyKills)
        print("Total Ants:  ")
        puts (@ants.size)
        counter1=0
        counter2=0
        for i in 0..@ants.size-1
            if(@ants[i].ant_type == 1)
                counter1+=1
            elsif(@ants[i].ant_type == 2)
                counter2+=1
            end
        end
        print("Forager Ants:  ")
        puts (counter2)
        print("Warrior Ants:  ")
        puts (counter1)
        puts ("================")
        
    end
    # Program output for dead colonies.
    
    def printDeadHills
        puts ("AntHill Name:  " + @name)
        print("Ant Kills:  ")
        puts (@antsKills)
        print("Colony Kills:  ")
        puts (@colonyKills)
        print("Total Ants:  ")
        puts (@ants.size)
        puts ("================")
    end
    
    # Function for creating new ants according to find new foods on the meadow.
    #If food<0 no new ants are created.
    def newAntCreation #create new ant
        oldSize = @ants.size
        @food.times do |i|
            ant = create_ant(name)
            @ants << ant
        end
        
        for i in oldSize..@ants.size-1
            r = rand(1..2)
            if r == 1
                @ants[i].ant_type=1
            else
                @ants[i].ant_type=2
            end
            @ants[i].ant_locX = @loc_x
            @ants[i].ant_locY = @loc_y
        end

        @food = 0
        
    end #end newAntCreation function
    
    
    #Sets the first ant location after anthill location is setted.
    def setLoc(loc_x,loc_y) # set first ant location
        
        @loc_x=loc_x
        @loc_y=loc_y
        for i in 0..@ants.size-1
            @ants[i].ant_locX = @loc_x
            @ants[i].ant_locY = @loc_y
        end
    end #end setLoc function

    # Ant can go four locations(left, right, up and down).
    #This function chechks the border of the meadow for suitable moves and calls move function to move the ant.
    def checkMove

        for i in 1..@ants.size-1 # all ants except queen
            moves=[ 1,1,1,1]
            
            if @ants[i].ant_locX == 0
                moves[0]= -1
            elsif @ants[i].ant_locX == 24
                moves[1]= -1
            end
            
            if @ants[i].ant_locY == 0
                moves[2]= -1
            elsif @ants[i].ant_locY == 24
                moves[3]= -1
            end
            
            
            r = rand(0..3)
            while (moves[r] == -1)
                r = rand(0..3)
            end
            
            if r == 0 #left
                @ants[i].move((@ants[i].ant_locX)-1,@ants[i].ant_locY)
            elsif r == 1 #right
                @ants[i].move((@ants[i].ant_locX)+1,@ants[i].ant_locY)
            elsif r == 2 #up
                @ants[i].move(@ants[i].ant_locX,(@ants[i].ant_locY)-1)
            elsif r == 3 #down
                @ants[i].move(@ants[i].ant_locX,(@ants[i].ant_locY)+1)
            end
            
        end #end for
        
    
    end #end checkMove
    
    
end #end class
