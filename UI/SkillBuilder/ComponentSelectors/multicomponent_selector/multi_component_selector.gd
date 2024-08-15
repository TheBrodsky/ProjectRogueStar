extends PanelContainer
class_name MultiComponentSelector


@onready var adder: ComponentAdder = $VBoxContainer/ComponentAdder
@onready var selected_components: VBoxContainer = $VBoxContainer/SelectedComponents
@onready var label: Label = $VBoxContainer/Label
@onready var line_item_packed: PackedScene = preload("res://scenes/UI/SkillBuilder/ComponentSelectors/multicomponent_selector/MultiComponentLineItem.tscn")

@export var action_chain_resource_type: GlobalEnums.ActionChainResourceType:
	set(value):
		action_chain_resource_type = value
		if label != null:
			label.text = GlobalEnums.ActionChainResourceTypeNames[action_chain_resource_type]
		if adder != null:
			adder.action_chain_resource_type = value


func _ready() -> void:
	action_chain_resource_type = action_chain_resource_type # forces setter call after @onready


func get_components() -> Array[Node]:
	var components: Array[Node] = []
	for line_item: MultiComponentLineItem in selected_components.get_children():
		components.append(line_item.get_component())
	return components


func _on_add_button_pressed() -> void:
	var resource_scene: PackedScene = adder.get_selected_resource()
	var line_item: MultiComponentLineItem = line_item_packed.instantiate()
	selected_components.add_child(line_item)
	line_item.component_node = resource_scene.instantiate()
	line_item.label.text = adder.get_selected_resource_name()
