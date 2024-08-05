extends Node


const INT64_MAX = 9223372036854775807

@export_category("Player Collisions")
@export_flags_2d_physics var player_effect_collision_layer: int
@export_flags_2d_physics var player_effect_collision_mask: int

@export_category("Enemy Collisions")
@export_flags_2d_physics var enemy_collision_layer: int
@export_flags_2d_physics var enemy_collision_mask: int
@export_flags_2d_physics var enemy_effect_collision_layer: int
@export_flags_2d_physics var enemy_effect_collision_mask: int
