extends Event


@export var projectile_blueprint: PackedScene = preload("res://scenes/projectiles/Bullet.tscn")


func _ready() -> void:
	super._ready()
	_name = "SingleProjectile"


func _do_event_action(container : EventContainer) -> void:
	_fire_projectile(container)


func _fire_projectile(container : EventContainer) -> void:
	var projectile: Node2D = projectile_blueprint.instantiate()
	container.add_entity(projectile)
	var new_rotation: float = container.state.calc_direction_from_points(projectile.global_position, get_global_mouse_position())
	container.state.modify(projectile)
	projectile.rotation = new_rotation
	
