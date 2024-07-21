extends Control
class_name SkillBuilder


@export var graph_save_directory: String = "res://saved_chains"

@onready var graph_container: TabContainer = $PanelContainer/TabContainer

var _prev_mouse_mode: int


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		if visible:
			close_graph()
		else:
			open_graph()


func build_chains() -> Array[ChainRoot]:
	var chains: Array[ChainRoot] = []
	for child in graph_container.get_children():
		chains.append((child as SkillBuilderGraph).build_chain())
	return chains


func open_graph() -> void:
	_prev_mouse_mode = Input.mouse_mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	show()


func close_graph() -> void:
	Input.set_mouse_mode(_prev_mouse_mode)
	get_tree().paused = false
	hide()


func save_graphs() -> void:
	var packed_chains: Array[PackedScene] = _pack_chains()
	var packed_graphs: Array[PackedScene] = _pack_graphs()
	for i in packed_chains.size():
		var dir: String = graph_save_directory.path_join(str(i))
		ScenePacker.savePackedScene(packed_chains[i], dir, "chain_%s.tscn" % i)
		ScenePacker.savePackedScene(packed_graphs[i], dir, "graph_%s.tscn" % i)


func load_graphs() -> void:
	var graph: PackedScene = load("res://saved_chains/0/graph_0.tscn")
	graph_container.add_child(graph.instantiate())


func _pack_chains() -> Array[PackedScene]:
	var packed_chains: Array[PackedScene] = []
	for chain in build_chains():
		packed_chains.append(ScenePacker.packScene(chain))
	return packed_chains


func _pack_graphs() -> Array[PackedScene]:
	var packed_graphs: Array[PackedScene] = []
	for graph in graph_container.get_children():
		packed_graphs.append(ScenePacker.packScene(graph))
	return packed_graphs


func _on_save_button_pressed() -> void:
	save_graphs()


func _on_load_button_pressed() -> void:
	load_graphs()
