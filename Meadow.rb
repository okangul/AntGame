#Nilay Altun
#Okan Gul
#Idil Sukas

require 'singleton'

require_relative 'Cell'
require_relative 'AntHillBase'

class Meadow
    include Singleton
    
    def initialize
        
        @grid = Array.new(25) { Array.new(25) } #create grid 25x25 by using Cell class
        for i in 0..24
            for j in 0..24
                @grid[i][j]=Cell.new
            end
        end
    
        @antHillArr = []
        @antHillDead = []
        @antHillArr << AntFactory.new(5,"Jake")
        @antHillArr << AntFactory.new(5,"Nilay")
        @antHillArr << AntFactory.new(5,"Idil")
        @antHillArr << AntFactory.new(5,"Dan")
        @antHillArr << AntFactory.new(5,"Okan")
        @antHillArr << AntFactory.new(5,"Alican")
        @antHillArr << AntFactory.new(5,"Gulce")
        @antHillArr << AntFactory.new(5,"John")
        @antHillArr << AntFactory.new(5,"Emma")
        @antHillArr << AntFactory.new(5,"Sara")

        changeAntType
        
        foodSpawn
        
        # Releases the queen ant for deploying the anthill.
        releaseQueen

    end #end initialize
    
    
     # Releases the queen ant for deploying the anthill. Ant_type = 0 . Goes a random place at grill
     #and change anthill to 1 to build anthill.
    def releaseQueen
        
        for i in 0..@antHillArr.size-1
            @antHillArr[i].ants[0].ant_type=0 #queen
            x=rand(24)+0
            y=rand(24)+0
            @grid[x][y].hill = 1
            @grid[x][y].food = nil
            @grid[x][y].cellName = @antHillArr[i].name
            @antHillArr[i].setLoc(x,y)
        end
    end
    
    # Prints the output of the program by calling both printhills and printdeadhills for full inforamtion.
    
    def print
        for i in 0..@antHillArr.size-1
            @antHillArr[i].printHills
        end
        for j in 0..@antHillDead.size-1
            @antHillDead[j].printDeadHills
        end
    
    end

    # Simualte function for starting new round while anthill number >1
    def startSimulate
        i = 0
        while(@antHillArr.size >  1)
            simulate
            if i % 5 == 0
                puts "New Tour"
                print
            end
            i += 1
        end

        puts "XXXXXXXXXXX"
        puts "Winner Ants Hill : #{@antHillArr[0].name}"
        puts "Total Ant Kills: #{@antHillArr[0].antsKills}"
        puts "Total Colony Kills: #{@antHillArr[0].colonyKills}"
    end
    
    #simulate 1 round for game
    def simulate
        
        #Clear cells for new movements.
        
        for i in 0..24
            for j in 0..24
                @grid[i][j].cellAnts.clear
            end
        end
        #Starts the ant move.
        #After the all ants finishes their moves for that round it sends new locations of ants
        #to the cell objects.
        for i in 0..@antHillArr.size-1
            @antHillArr[i].checkMove
            for j in 1..@antHillArr[i].ants.size-1
                @grid[@antHillArr[i].ants[j].ant_locX][@antHillArr[i].ants[j].ant_locY].cellAnts << @antHillArr[i].ants[j]
            end
        end

        #food harvest
        #For every single cell object it calls and done fight function if it needed
        #or harvest if it is needed to proceed all of the process.
        
        for i in 0..24
            for j in 0..24
                if @grid[i][j].hill == 1 # if there is hill in cell object and there is a enemy ant in it it start the fight. (with %20 winning possibilty)
                    r = rand(1..5)
                    if r == 3
                        for k in 0..@grid[i][j].cellAnts.size-1
                            if @grid[i][j].cellAnts[k].ant_type == 1 && @grid[i][j].cellAnts[k].family_name != @grid[i][j].cellName
                                    @grid[i][j].hill = 0
                                    for n in 0..@antHillArr.size-1
                                        if @grid[i][j].cellAnts[k].family_name == @antHillArr[n].name #winner
                                            @antHillArr[n].colonyKills+=1
                                            break
                                        end
                                    end
                                    
                                    for m in 0..@antHillArr.size-1
                                        if @grid[i][j].cellName == @antHillArr[m].name
                                            @antHillArr[m].ants.clear #loser
                                            @antHillArr[m].food = nil
                                            @antHillDead << @antHillArr[m]
                                            @antHillArr.delete(@antHillArr[m])
                                            break
                                        end
                                    end
                                    
                                    

                            end
                        end
                        
                    end
                    
                elsif @grid[i][j].cellAnts.size == 1 # if the cell include only one ant.
                    if @grid[i][j].cellAnts[0].ant_type == 2 #if ant is forager (it means no war just harvest)
                        if @grid[i][j].food == 1
                            @grid[i][j].food = nil
                            harvest(i,j,0)
                        end
                    end
                    
                elsif @grid[i][j].cellAnts.size > 1 #if the cell includes more than one ant.
                    #split to ants by using their types
                    warriors = [] #type 1
                    foragers = [] #type 2

                    for k in 0..@grid[i][j].cellAnts.size-1
                        if @grid[i][j].cellAnts[k].ant_type == 1
                            warriors << @grid[i][j].cellAnts[k]
                            
                        elsif @grid[i][j].cellAnts[k].ant_type == 2
                            foragers << @grid[i][j].cellAnts[k]
                        end
                    end
                    #end of split
                    
                    if warriors.size == 0 #if warrior array is empty than foregers can harvest(no war)
                        if @grid[i][j].food == 1
                            @grid[i][j].food = nil
                            for m in 0..foragers.size-1
                                harvest(i,j,m)
                            end
                        end
                        
                    elsif warriors.size == 1 #if there is just one warriors all the foragers should die.
                        for m in 0..foragers.size-1
                            countAntKills(warriors[0])
                            dead(foragers[m])
                        end
                        #kill foragers.
                    
                    elsif warriors.size > 1 #if there is more than one warrior choose winner random with fight.
                        winnerIndex = rand(0..warriors.size-1)
                        for m in 0..warriors.size-2
                            countAntKills(warriors[winnerIndex])
                        end
                        
                        for n in 0..warriors.size-1
                            if n != winnerIndex
                                dead(warriors[n])
                            end
                        end
                        #delete dead warriors.

                        if foragers.size > 0 # While warriors are fighting foragers harvest food and dont die.
                            if @grid[i][j] ==1
                                @grid[i][j].food = nil
                                
                                for m in 0..foragers.size-1
                                    harvest(i,j,m)
                                end
                            end
                        end
                    end

                end #end control if
                
            end #end grid
        end #end grid
        
        #foodSpawn
        #Spawns new food randomly.
        
        for c in 0..@antHillArr.size-1
            @antHillArr[c].newAntCreation
        end


    end #end simulate function
    
    
    def countAntKills(ant) #Increment the antkill number for the winner colony.
        
        for a in 0..@antHillArr.size-1
            if ant.family_name == @antHillArr[a].name
                @antHillArr[a].antsKills+=1
            end
        end
        
    end #end countAntKills
    
    
    def dead(ant) #Erease the dead ants from the array.(From their own colony ant arrays.)
        
        for a in 0..@antHillArr.size-1
            if ant.family_name == @antHillArr[a].name
                @antHillArr[a].ants.delete(ant)
            end
        end
        
    end #end dead
    
    # harvest food if a cell object contains food than  "JUST ONLY" foragers can harvest that food.
    def harvest(i,j,k)

        for a in 0..@antHillArr.size-1
            if @grid[i][j].cellAnts[k].family_name == @antHillArr[a].name
                @antHillArr[a].food += 1
            end
        end
        
    end #end harvest


    def foodSpawn #spawn foods for every turn
        for i in 0..24
            for j in 0..24
                @grid[i][j].food = nil
            end
        end
    
        foodLocX = []
        foodLocY = []
    
        for i in 0..4
            foodLocX[i]=rand(0..24)
            foodLocY[i]=rand(0..24)
            @grid[foodLocX[i]][foodLocY[i]].food=1
        end
      
    end #end foodSpawn


    def changeAntType #change ant type
        #run time modification
        for i in 0..@antHillArr.size-1
            class<<@antHillArr[i]
                def change_warrior(m)
                    ants[m].ant_type = 1
                end
                def change_forager(n)
                    ants[n].ant_type = 2
                end
            end

            r0forager = rand(1..@antHillArr[i].ants.size-2);
            r0warior =  (@antHillArr[i].ants.size-2) - r0forager

            for j in 1..r0forager+1
                @antHillArr[i].change_forager(j)
            end

            for k in r0forager+2..@antHillArr[i].ants.size-1
                @antHillArr[i].change_warrior(k)
            end
        end

    end #end changeAntType func


end #end class
