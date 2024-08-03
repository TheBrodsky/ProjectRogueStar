extends ResourcePreloader


@export var dir_path: String = ""


func _ready() -> void:
	if dir_path.length() > 0:
		populate_resources(open_directory(dir_path))


func populate_resources(directory: DirAccess) -> void:
	if directory != null:
		for file in directory.get_files():
			if file.get_extension() == "tscn": # if file is scene
				var scene_path: String = directory.get_current_dir().path_join(file)
				var scene_name: String = file.get_slice(".", 0)
				Logger.log_info("Loading scene into ResourcePreloader: %s" %scene_path)
				add_resource(scene_name, load(directory.get_current_dir().path_join(file)))
		
		for sub_dir in directory.get_directories():
			sub_dir = directory.get_current_dir().path_join(sub_dir)
			populate_resources(open_directory(sub_dir))


func open_directory(path: String) -> DirAccess:
	var dir: DirAccess = DirAccess.open(path)
	if dir == null:
			Logger.log_error("Could not open directory (%s) due to error %s" % [path, DirAccess.get_open_error()])
	return dir
