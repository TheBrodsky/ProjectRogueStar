extends HBoxContainer
class_name ComponentAdder


@onready var component_list: OptionButton = $ComponentList

@export var action_chain_resource_type: GlobalEnums.ActionChainResourceType:
	set(value):
		action_chain_resource_type = value
		if component_list.item_count > 0:
			component_list.clear()
			_populate_item_selections()


func _ready() -> void:
	_populate_item_selections()


func get_selected_resource_name() -> String:
	return component_list.get_item_text(component_list.selected)


func get_selected_resource() -> PackedScene:
	return Globals.get_resource(get_selected_resource_name(), action_chain_resource_type)


func _populate_item_selections() -> void:
	for resource_name: String in Globals.get_resource_list(action_chain_resource_type):
		component_list.add_item(resource_name)

