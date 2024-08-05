extends Node2D


@onready var Player: Player = $Player
@onready var Respawn: Marker2D = $PlayerSpawnPoint
@onready var Reticle: Area2D = $Reticle
#@onready var Skill_Builder: SkillBuilder = $Camera/CanvasLayer/SkillBuilder # TODO


func _ready() -> void:
	respawn()
	#Skill_Builder.visibility_changed.connect(_on_skill_builder_visibility_changed) # TODO
	#Skill_Builder.close_graph()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_filedialog_refresh"):
		respawn()


func respawn() -> void:
	Player.global_position = Respawn.global_position
	get_tree().call_group("projectile", "queue_free")


# TODO
#func _on_skill_builder_visibility_changed() -> void:
	#if not Skill_Builder.visible:
		#var action_chains: Array[ChainRoot] = Skill_Builder.build_chains()
		#for chain: ChainRoot in action_chains:
			#add_child(chain)

