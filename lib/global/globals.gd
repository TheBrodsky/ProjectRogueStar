extends Node


const INT64_MAX: int = 9223372036854775807

# strings for common export category names
const MODIFIABLE_CATEGORY: String = "Modifiable Stats"
const INSPECTOR_CATEGORY: String = "Inspector Only"
const PRIVATE_CATEGORY: String = "Private: DO NOT SET"


@export_category("Player Collisions")
@export_flags_2d_physics var player_effect_collision_layer: int
@export_flags_2d_physics var player_effect_collision_mask: int

@export_category("Enemy Collisions")
@export_flags_2d_physics var enemy_collision_layer: int
@export_flags_2d_physics var enemy_collision_mask: int
@export_flags_2d_physics var enemy_effect_collision_layer: int
@export_flags_2d_physics var enemy_effect_collision_mask: int
