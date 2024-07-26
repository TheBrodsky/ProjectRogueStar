extends TriggerHook
class_name HitTriggerHook
signal register_hit(body: Node2D)


#region mirrored hit register setters
@export var collision_node: Area2D:
	set(value):
		collision_node = value
		hit_register.collision_node = value

@export_flags_2d_physics var collision_mask: int:
	set(value):
		collision_mask = value
		hit_register.collision_mask = value

@export var mask_is_blacklist: bool = false:
	set(value):
		mask_is_blacklist = value
		hit_register.mask_is_blacklist

@export var include_tilemaps: bool = false:
	set(value):
		include_tilemaps = value
		hit_register.include_tilemaps = value

@export var hit_condition_method: Callable:
	set(value):
		hit_condition_method = value
		hit_register.hit_condition_method = value
#endregion

@export var hit_register: HitRegister ## Probably just leave this alone unless you know what you're doing


func perform_additional_setup(trigger: Trigger, state: ActionState) -> void:
	register_hit.connect((trigger as HitTrigger).hit)
	


## Echo child register_hit signal
func _on_hit_register_register_hit(body: Node2D) -> void:
	register_hit.emit(body)
