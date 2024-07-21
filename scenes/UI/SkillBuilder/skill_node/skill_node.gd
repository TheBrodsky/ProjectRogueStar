class_name SkillNode
extends GraphNode
signal on_delete(node_name: StringName)


enum ActionNodeType {Trigger, Event, Root} # Root is not a configurable type from within the editor. See _on_gui_input()
static var ActionNodeTypeName: Array[String] = ["Trigger", "Event", "Chain Root"]
@export var skill_node_type: ActionNodeType = ActionNodeType.Trigger:
	set(value):
		skill_node_type = value
		_update_styling()
		if trigger_builder != null: # the first set (from a non-default export value) happens before the @onready vars below
			_show_relevant_lists()

@export var trigger_color: Color = Color.CORAL
@export var event_color: Color = Color.STEEL_BLUE
@export var root_color: Color = Color.DARK_OLIVE_GREEN


@onready var trigger_builder: TriggerBuilder = $VBoxContainer/TriggerBuilder
@onready var event_builder: EventBuilder= $VBoxContainer/EventBuilder
@onready var root_builder: RootBuilder= $VBoxContainer/RootBuilder
@onready var modifier_selector: MultiComponentSelector = $VBoxContainer/ModifierSelector


func _ready() -> void:
	skill_node_type = skill_node_type # for some reason, the setter in skill_node_type doesnt run initially despite the default value. This fixes that.
	_show_relevant_lists()


func _process(delta: float) -> void:
	if selected and skill_node_type != ActionNodeType.Root and Input.is_action_pressed("ui_text_delete"):
		on_delete.emit(name)
		queue_free()


#region chain assembly
## main method for building the entire action chain. Typically called from the root SkillNode and recursively travels down
func build_chain(connections_from: Dictionary) -> ActionNode:
	var return_node: ActionNode
	var connections_from_this_node: Dictionary = {}
	if name in connections_from:
		connections_from_this_node = connections_from[name]
	
	# base case
	if connections_from_this_node.size() == 0:
		return_node = create_action_node()
	else:
		# recursive case
		return_node = create_action_node()
		for other_skill_node: SkillNode in connections_from_this_node.values():
			var child_node: ActionNode = other_skill_node.build_chain(connections_from)
			return_node.add_child(child_node)
	return return_node


## method for an individual SkillNode assembling its relevant action node
func create_action_node() -> ActionNode:
	var action_node: ActionNode = null
	match skill_node_type:
		ActionNodeType.Trigger:
			action_node = trigger_builder.assemble_trigger_node()
		ActionNodeType.Event:
			action_node = event_builder.assemble_event_node()
		ActionNodeType.Root:
			action_node = root_builder.assemble_root_node()
	return action_node

#endregion


#region list display control
func _show_relevant_lists() -> void:
	_hide_all_builders()
	match skill_node_type:
		ActionNodeType.Trigger:
			trigger_builder.show()
		ActionNodeType.Event:
			event_builder.show()
		ActionNodeType.Root:
			root_builder.show()


func _hide_all_builders() -> void:
	trigger_builder.hide()
	event_builder.hide()
	root_builder.hide()


func switch_node_type(compared_node: SkillNode = null) -> void:
	var compared_type: ActionNodeType = skill_node_type
	if compared_node != null:
		compared_type = compared_node.skill_node_type
	
	if compared_type == ActionNodeType.Event: # Event leads into Trigger
		skill_node_type = ActionNodeType.Trigger
	else: # both ChainRoot and Trigger lead into Event
		skill_node_type = ActionNodeType.Event


func _update_styling() -> void:
	title = ActionNodeTypeName[skill_node_type]
	match skill_node_type:
		ActionNodeType.Trigger:
			modulate = trigger_color
		ActionNodeType.Event:
			modulate = event_color
		ActionNodeType.Root:
			set_slot_enabled_left(0, false) # root nodes cannot be input into
			modulate = root_color
#endregion


func _get_option_button_text(button: OptionButton) -> String:
	var option_text: String = ""
	var selected: int = button.get_selected_id()
	if selected > -1:
		option_text = button.get_item_text(selected)
	return option_text


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event as InputEventMouseButton
		var is_right_click: bool = mouse_event.button_index == MOUSE_BUTTON_RIGHT  and mouse_event.pressed
		if is_right_click and skill_node_type != ActionNodeType.Root: # Root nodes can't be changed or created
			switch_node_type()
