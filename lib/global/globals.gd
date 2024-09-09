extends Node


const INT64_MAX: int = 9223372036854775807

# strings for common export category names
const MODIFIABLE_CATEGORY: String = "Modifiable" # read/write public fields
const INSPECTOR_CATEGORY: String = "Inspector Only" # read-only public fields, typically used when pre-ready access is desired
const PRIVATE_CATEGORY: String = "Private: DO NOT SET" # private fields, typically used when field should be copied by duplicate()


@export_category("Player Collisions")
@export_flags_2d_physics var player_effect_collision_layer: int
@export_flags_2d_physics var player_effect_collision_mask: int

@export_category("Enemy Collisions")
@export_flags_2d_physics var enemy_collision_layer: int
@export_flags_2d_physics var enemy_collision_mask: int
@export_flags_2d_physics var enemy_effect_collision_layer: int
@export_flags_2d_physics var enemy_effect_collision_mask: int
