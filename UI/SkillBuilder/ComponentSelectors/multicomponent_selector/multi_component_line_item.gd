extends HBoxContainer
class_name MultiComponentLineItem


@onready var label: Label = $Label
@onready var edit_button: TextureButton = $EditButton
@onready var delete_button: TextureButton = $DeleteButton
@onready var property_editor_packed: PackedScene = preload("res://scenes/UI/SkillBuilder/property_editor/PropertyEditor.tscn")

var component_node: Node = null
var _node_property_editor: PropertyEditor = null


func get_component() -> Node:
	return component_node


func _open_node_property_editor() -> void:
	if component_node != null:
		if _node_property_editor == null:
			_node_property_editor = _create_node_property_editor(component_node)
		_node_property_editor.popup()


func _create_node_property_editor(node: Node) -> PropertyEditor:
	var editor: PropertyEditor = property_editor_packed.instantiate()
	add_child(editor)
	editor.populate_editor(node)
	return editor


func _on_edit_button_pressed() -> void:
	_open_node_property_editor()


func _on_delete_button_pressed() -> void:
	component_node.queue_free()
	queue_free()
