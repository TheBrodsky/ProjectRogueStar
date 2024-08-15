extends HBoxContainer
class_name ComponentSelector


@onready var label: Label = $Label
@onready var component_list: OptionButton = $ComponentList
@onready var edit_button: TextureButton = $EditButton
@onready var property_editor_packed: PackedScene = preload("res://scenes/UI/SkillBuilder/property_editor/PropertyEditor.tscn")

@export var action_chain_resource_type: GlobalEnums.ActionChainResourceType

var _component_node: Node = null
var _node_property_editor: PropertyEditor = null


func _ready() -> void:
	_populate_item_selections()
	_on_item_selected(0) # select item at 0 index as default (the OptionList already does this; this code just reflects that)
	_set_label()


func get_component_node() -> Node:
	if _component_node.has_method("clone"):
		@warning_ignore("unsafe_method_access")
		return _component_node.clone()
	else:
		return _component_node


func get_packed_component() -> PackedScene:
	return ScenePacker.packScene(get_component_node())


func override_options(new_options: Array[String]) -> void:
	component_list.clear()
	for option in new_options:
		component_list.add_item(option)
	_on_item_selected(0)


func _set_label() -> void:
	label.text = GlobalEnums.ActionChainResourceTypeNames[action_chain_resource_type]


func _populate_item_selections() -> void:
	for resource_name: String in ComponentLoader.get_resource_list(action_chain_resource_type):
		component_list.add_item(resource_name)


func _on_item_selected(index: int) -> void:
	if _component_node != null:
		_component_node.queue_free()
		if _node_property_editor != null:
			_node_property_editor.queue_free()
			_node_property_editor = null # the editor is only ever created at the time it's needed, so we set this to null in the meantime
	_component_node = _get_resource(index).instantiate()


func _get_resource(index: int) -> PackedScene:
	return ComponentLoader.get_resource(component_list.get_item_text(index), action_chain_resource_type)


func _open_node_property_editor() -> void:
	if _component_node != null:
		if _node_property_editor == null:
			_node_property_editor = _create_node_property_editor(_component_node)
		_node_property_editor.popup()


func _create_node_property_editor(node: Node) -> PropertyEditor:
	var editor: PropertyEditor = property_editor_packed.instantiate()
	add_child(editor)
	editor.populate_editor(node)
	return editor


func _on_component_list_item_selected(index: int) -> void:
	_on_item_selected(index)


func _on_edit_button_pressed() -> void:
	_open_node_property_editor()
