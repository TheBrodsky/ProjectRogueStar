extends TriggerHook
class_name HitTriggerHook
signal register_hit(body: Node2D)


@export var hit_register: HitRegister

@export var collision_node: Area2D:
	set(value):
		collision_node = value
		hit_register.collision_node = value

@export var group_whitelist: Array[String]:
	set(value):
		group_whitelist = value
		hit_register.group_whitelist = value

@export var group_blacklist: Array[String]:
	set(value):
		group_blacklist = value
		hit_register.group_blacklist = value

@export var hit_condition_method: Callable:
	set(value):
		hit_condition_method = value
		hit_register.hit_condition_method = value


func perform_additional_setup(trigger: Trigger, state: ActionState) -> void:
	register_hit.connect((trigger as HitTrigger).hit)
	


## Echo child register_hit signal
func _on_hit_register_register_hit(body: Node2D) -> void:
	register_hit.emit(body)
