extends PathingManager

func modify_emission(emission : Emission):
	emission.add_child(pathing_scene.instantiate())
