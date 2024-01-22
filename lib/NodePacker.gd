extends Object

class_name NodePacker


static func packNode(node) -> PackedScene:
	var scene = PackedScene.new()
	var result = scene.pack(node)
	if result != OK:
		Logger.log_error("Failed to pack scene %s, result: %s" % [node, result])
		scene = null
	return scene
