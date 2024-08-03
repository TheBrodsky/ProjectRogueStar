extends Node

## The SignalBus defines signals that allow nodes to hook into "all instances"
## of a signal easily. The original example of this was the problem "how do I
## make something respond to ANY instance of an enemy dying without having to
## connect to every enemy's death signal." The solution is to define a global
## death signal and then have enemies emit both their local death signal and 
## this global signal.

signal enemy_died(enemy: Node2D)
