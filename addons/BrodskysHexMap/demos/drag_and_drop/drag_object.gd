extends Control
class_name Draggable

signal drag_completed(draggable: Draggable)


var source: Control
var object: Variant
var preview: Control


func _init(source: Control, object: Variant, preview: Control) -> void:
	self.source = source
	self.object = object
	self.preview = preview
	self.preview.tree_exiting.connect(_on_tree_exiting)
	add_child(self.preview)


func _process(delta: float) -> void:
	preview.global_position = get_global_mouse_position()


func _on_tree_exiting() -> void:
	drag_completed.emit(self)
