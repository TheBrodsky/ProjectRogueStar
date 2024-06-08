class_name Draggable
extends ColorRect


var fallback_parent: Node


func _enter_tree() -> void:
	if fallback_parent == null:
		fallback_parent = get_parent()


# Step 1 of 3 in DragNDrop. Initiates dragging and returns the dragged object (this)
func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(_get_preview_control())
	modulate.a = .4
	return self


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_END:
			modulate.a = 1


func on_drop(drop_area: DropArea) -> void:
	var prev_parent: Node = get_parent()
	var occupying_draggable: Draggable = drop_area.get_occupying_draggable()
	if occupying_draggable != null and occupying_draggable != self:
		occupying_draggable.return_to_fallback_parent() # kick out existing draggable
	
	reparent(drop_area)
	position = Vector2.ZERO
	
	if prev_parent is DropArea:
		(prev_parent as DropArea).update()


func return_to_fallback_parent() -> void:
	reparent(fallback_parent)


func _get_preview_control() -> Control:
	"""
	DO NOT ADD PREVIEW CONTROL TO SCENE TREE. DO NOT FREE IT. DO NOT KEEP A REFERENCE TO IT BEYOND DRAG.
	"""
	var preview: Control = self.duplicate()
	return preview


func _on_mouse_entered() -> void:
	pass # Replace with function body.
