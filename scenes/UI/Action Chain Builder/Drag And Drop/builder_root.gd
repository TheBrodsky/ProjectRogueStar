class_name BuilderRoot
extends HBoxContainer


@export var drop_area_blueprint: PackedScene = preload("res://scenes/UI/Action Chain Builder/Drag And Drop/DropArea.tscn")
@export var root: ChainRoot

var num_areas: int = 1

func _ready() -> void:
	for i in num_areas:
		add_child(drop_area_blueprint.instantiate())


func restructure() -> void:
	for child in get_children():
		if (child as DropArea).get_occupying_draggable() == null:
			child.queue_free()
	add_child(drop_area_blueprint.instantiate())
