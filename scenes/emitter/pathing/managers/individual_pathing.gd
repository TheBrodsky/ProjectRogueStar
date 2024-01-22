extends PathingManager

func modify_emission(emission : Emission):
	for child in emission.get_children():
		child.add_child(pathing_scene.instantiate())
