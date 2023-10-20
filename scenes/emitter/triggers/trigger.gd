extends Node

class_name Trigger

signal triggered


var _paused = false


func pause():
	_paused = true
	set_process(false)


func unpause():
	_paused = false
	set_process(true)
