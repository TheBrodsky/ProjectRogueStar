extends CharacterBody2D
class_name Enemy


@onready var health_bar: HealthBar = $HealthBar

@export_group(Globals.INSPECTOR_CATEGORY)
@export var iaction: ActionInterface


func _ready() -> void:
	add_to_group("Enemy")
	add_to_group("Hittable")
	collision_layer = Globals.enemy_collision_layer
	collision_mask = Globals.enemy_collision_mask


func take_damage(damage: float) -> void:
	health_bar.reduce(damage)


func die() -> void:
	iaction.signaler.died.emit(iaction.state)
	queue_free()


func _on_health_bar_no_health() -> void:
	die()

