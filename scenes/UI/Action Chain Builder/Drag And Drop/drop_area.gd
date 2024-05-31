class_name DropArea
extends ColorRect


var parent_container: BuilderRoot


func _enter_tree() -> void:
	parent_container = get_parent()


# Step 2 of 3 in DragNDrop. Specifies whether this is a valid place to drop the draggable ("data")
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Draggable


# Step 3 of 3 in DragNDrop. Performs any necessary steps to "drop" the draggable ("data").
func _drop_data(at_position: Vector2, data: Variant) -> void:
	(data as Draggable).on_drop(self)
	update()


func update() -> void:
	parent_container.restructure()


func get_occupying_draggable() -> Draggable:
	var occupying_draggable: Draggable = null
	for child in get_children():
		if child is Draggable:
			occupying_draggable = child
	return occupying_draggable
	
