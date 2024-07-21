extends Window
class_name PropertyEditor


@export var blacklisted_types: Array[String] = ["PackedScene", "Effect"]

@onready var panel_container: PanelContainer = $PanelContainer


func populate_editor(node: Node) -> void:
	title = node.name
	panel_container.add_child(_create_exported_property_container(node))


func _on_close_requested() -> void:
	hide()


func _create_exported_property_container(node: Node) -> Container:
	var properties: Array[Dictionary] = _get_exported_properties_of_node(node)
	var scroll_box: ScrollContainer = ScrollContainer.new()
	var container: VBoxContainer = VBoxContainer.new()
	scroll_box.add_child(container)
	for property in properties:
		_add_property_to_container(node, property, container)
	return scroll_box


func _get_exported_properties_of_node(node: Node) -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for property in node.get_property_list():
		var is_exported: bool = property["usage"] & PROPERTY_USAGE_EDITOR
		var is_script_property: bool = property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE 
		if is_script_property and is_exported:
			properties.append(property)
	return properties


func _add_property_to_container(node: Node, property: Dictionary, container: Container) -> void:
	var property_name: String = property["name"]
	var property_type: int = property["type"]
	var property_value: Variant = node.get(property_name)
	
	var input: Control
	match property_type:
		TYPE_BOOL:
			var check_box: CheckBox = CheckBox.new()
			check_box.button_pressed = property_value
			check_box.toggled.connect(Callable(self, "_on_property_changed").bind(node, property_name))
			input = check_box
		TYPE_INT, TYPE_FLOAT:
			var spin_box: SpinBox = SpinBox.new()
			if property_type == TYPE_FLOAT:
				spin_box.step = .1
			if property_value < 0:
				spin_box.min_value = property_value
			@warning_ignore("unsafe_call_argument")
			spin_box.set_value_no_signal(property_value)
			spin_box.value_changed.connect(Callable(self, "_on_property_changed").bind(node, property_name))
			input = spin_box
		TYPE_STRING:
			var line_edit: LineEdit = LineEdit.new()
			line_edit.text = property_value
			line_edit.text_changed.connect(Callable(self, "_on_property_changed").bind(node, property_name))
			input = line_edit
		_:
			input = _handle_other_input_types(property, property_value)
	
	if input:
		var label: Label = Label.new()
		label.text = property_name
		container.add_child(label)
		container.add_child(input)


func _handle_other_input_types(property: Dictionary, property_value: Variant) -> Control:
	if property["class_name"] not in blacklisted_types:
		print(property)
	return null


func _on_property_changed(value: Variant, node: Node, property_name: String) -> void:
	node.set(property_name, value)
