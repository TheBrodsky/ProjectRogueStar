extends VBoxContainer
class_name RootBuilder


@export var whitelisted_triggers: Array[String] = ["OnTimer"]

@onready var trigger_list: ComponentSelector = $TriggerSelector
@onready var input_selector: OptionButton = $InputSelector/OptionButton
@onready var quant_mod_list: MultiComponentSelector = $QuantModSelector


func _ready() -> void:
	trigger_list.override_options(whitelisted_triggers)
	_set_input_options()


func assemble_root_node() -> ChainRoot:
	var root: ChainRoot = ChainRoot.new()
	root.input_type = input_selector.get_selected_id() # because of _set_input_options(), the index mapping from input_selector to InputTriggerButtonInputs is 1-to-1
	return add_mods(root)


func add_mods(root: ChainRoot) -> ChainRoot:
	for quant_mod: QuantitativeModifier in quant_mod_list.get_components():
		root.add_child(quant_mod)
	return root


func _set_input_options() -> void:
	for input_label: String in OnInput.InputTriggerButtonInputsLabels:
		input_selector.add_item(input_label)
