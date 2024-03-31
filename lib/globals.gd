extends Node


var _unsaved_ID_incrementor : int = 0 # Used for things that need a unique ID but do not care that it's consistent across game instances


func get_unsaved_ID() -> int:
	var ID: int = _unsaved_ID_incrementor
	_unsaved_ID_incrementor += 1
	return ID
