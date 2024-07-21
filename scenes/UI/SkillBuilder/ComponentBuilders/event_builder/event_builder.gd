extends VBoxContainer
class_name EventBuilder


@onready var action_list: ComponentSelector = $ActionSelector
@onready var effect_list: ComponentSelector = $EffectSelector
@onready var quant_mod_list: MultiComponentSelector = $QuantModSelector
@onready var container_mod_list: MultiComponentSelector = $ContainerModSelector
@onready var action_mod_list: MultiComponentSelector = $ActionModSelector

func assemble_event_node() -> Event:
	var event: Event = Event.new()
	event.action = action_list.get_packed_component()
	event.effect = effect_list.get_packed_component()
	return add_mods(event)


func add_mods(event: Event) -> Event:
	for quant_mod: QuantitativeModifier in quant_mod_list.get_components():
		event.add_child(quant_mod)

	for container_mod: ContainerModifier in container_mod_list.get_components():
		event.add_child(container_mod)
	
	for action_mod: ActionModifier in action_mod_list.get_components():
		event.add_child(action_mod)

	return event
