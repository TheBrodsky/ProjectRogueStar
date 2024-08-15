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
	var input: Control = _create_property_input(property, node)
	if input:
		var label: Label = Label.new()
		label.text = property["name"]
		container.add_child(label)
		container.add_child(input)


#region input control creation methods
func _create_property_input(property: Dictionary, node: Node) -> Control:
	var property_name: String = property["name"]
	var property_type: int = property["type"]
	var property_value: Variant = node.get(property_name)
	
	var input: Control
	match property_type:
		TYPE_BOOL:
			input = _create_bool_input(property_name, property_type, property_value, node)
		TYPE_INT, TYPE_FLOAT:
			input = _create_number_input(property_name, property_type, property_value, node, property)
		TYPE_STRING:
			input = _create_string_input(property_name, property_type, property_value, node)
		_:
			input = _handle_other_input_types(property, property_value)
	return input


func _create_bool_input(name: String, type: int, value: Variant, node: Node) -> Control:
	var check_box: CheckBox = CheckBox.new()
	check_box.button_pressed = value
	check_box.toggled.connect(Callable(self, "_on_property_changed").bind(node, name))
	return check_box


func _create_number_input(name: String, type: int, value: Variant, node: Node, property: Dictionary) -> Control:
	var spin_box: SpinBox = SpinBox.new()
	var hint_string: String = property["hint_string"]
	var range_values: PackedStringArray = hint_string.split(",")
	
	if range_values.size() > 1: # check if this property has metadata that defines a range and step size
		spin_box.min_value = float(range_values[0])
		spin_box.max_value = float(range_values[1])
		if range_values.size() == 3: # the 3rd value is step, but it's optional
			spin_box.step = float(range_values[2])
	else: # use defaults for range and step size
		if type == TYPE_FLOAT:
			spin_box.step = .1
		if value < 0:
			spin_box.min_value = value
	
	@warning_ignore("unsafe_call_argument")
	spin_box.set_value_no_signal(value)
	spin_box.value_changed.connect(Callable(self, "_on_property_changed").bind(node, name))
	return spin_box


func _create_string_input(name: String, type: int, value: Variant, node: Node) -> Control:
	var line_edit: LineEdit = LineEdit.new()
	line_edit.text = value
	line_edit.text_changed.connect(Callable(self, "_on_property_changed").bind(node, name))
	return line_edit


func _handle_other_input_types(property: Dictionary, property_value: Variant) -> Control:
	if property["class_name"] not in blacklisted_types:
		print(property)
	return null
#endregion


func _on_property_changed(value: Variant, node: Node, property_name: String) -> void:
	node.set(property_name, value)
