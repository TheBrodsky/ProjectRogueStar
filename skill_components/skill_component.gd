extends Node
class_name SkillComponent


@export var bottom_link: Node
@export var top_link: Node

var _next_events: Array[Event] = []
var _next_triggers: Array[Trigger] = []


func get_next_events() -> Array[Event]:
	if _next_events.is_empty():
		# populate array
		for child in get_children():
			if child is Event:
				_next_events.append(child)
	return _next_events


func get_next_triggers() -> Array[Trigger]:
	if _next_triggers.is_empty():
		# populate array
		for child in get_children():
			if child is Trigger:
				_next_triggers.append(child)
	return _next_triggers


func add_component(other: SkillComponent) -> void:
	bottom_link.add_child(other)
