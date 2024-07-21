extends Object
class_name ScenePacker


static var SYMBOLIC_DIRS: Array[String] = ["res:", "user:"]


static func packScene(node: Node, set_owner_to_node: bool = true) -> PackedScene:
	if set_owner_to_node:
		recursiveSetOwner(node, node)
	var scene: PackedScene = PackedScene.new()
	var result: int = scene.pack(node)
	if result != OK:
		Logger.log_error("Failed to pack scene")
	return scene


## Sets the owner of all descendents of owner/cur_node to owner. Unowned nodes will not be packed. Initial call should have the same node in both arguments.
static func recursiveSetOwner(owner: Node, cur_node: Node) -> void:
	if owner != cur_node:
		cur_node.owner = owner
	
	for child in cur_node.get_children():
		recursiveSetOwner(owner, child)


static func savePackedScene(scene: PackedScene, file_path: String, file_name: String) -> void:
	_buildDirectories(file_path)
	var full_path: String = file_path.path_join(file_name)
	var error: int = ResourceSaver.save(scene, full_path)
	if error != OK:
		Logger.log_error("Failed to save PackedScene at path %s with error %s" % [full_path, error])


## Some methods like ResourceSaver.save() wont create directories that dont exist. This does.
static func _buildDirectories(dir_path: String) -> void:
	var dir: DirAccess = DirAccess.open(dir_path)
	if not dir:
		var root: String = dir_path.split("/")[0]
		if root in SYMBOLIC_DIRS:
			root += "//"
		dir = DirAccess.open(root)
		if not dir:
			push_error("Root of directory path does not exist %s" % dir_path)
		dir.make_dir_recursive(dir_path)
