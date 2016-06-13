#Nilay Altun
#Okan Gul
#Idil Sukas

require_relative 'Meadow'
require_relative 'Ant'
require_relative 'AntHillBase'
require_relative 'AntFactory'


#Creates singleton object meadow, and calls simulate function for simulate the actions for
#meadow until there is only one anthill remains.
meadow = Meadow.instance
meadow.startSimulate