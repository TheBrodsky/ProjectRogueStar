extends VBoxContainer
class_name TriggerBuilder


@onready var trigger_list: ComponentSelector = $TriggerSelector
@onready var quant_mod_list: MultiComponentSelector = $QuantModSelector


func assemble_trigger_node() -> Trigger:
	return add_mods(trigger_list.get_component_node() as Trigger)


func add_mods(trigger: Trigger) -> Trigger:
	for quant_mod: QuantitativeModifier in quant_mod_list.get_components():
		trigger.add_child(quant_mod)
	return trigger
