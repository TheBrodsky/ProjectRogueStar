extends Node


@onready var unsaved_ID_incrementor = 0 # Used for things that need a unique ID but do not care that it's consistent across game instances


func get_unsaved_ID():
	var ID = unsaved_ID_incrementor
	unsaved_ID_incrementor += 1
	return ID
