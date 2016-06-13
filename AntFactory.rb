#Nilay Altun
#Okan Gul
#Idil Sukas

require_relative 'Ant'
require_relative 'AntHillBase'

#Factory funtion for creating new ants for anthill.
class AntFactory < AntHillBase
    
    def create_ant(family_name)
        Ant.new(family_name)
    end
end