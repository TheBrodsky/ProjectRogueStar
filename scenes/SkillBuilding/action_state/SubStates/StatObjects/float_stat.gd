extends Resource
class_name FloatStat


static func get_stat() -> FloatStat:
	var stat: FloatStat = FloatStat.new()
	stat.resource_local_to_scene = true
	return stat


@export var add: float = 0
@export var inc: float = 0
@export var mult: float = 1


func val() -> float:
	return add * (1 + inc) * mult


func merge(other: FloatStat) -> void:
	if other != null:
		add += other.add
		inc += other.inc
		mult *= other.mult


func scale(scalar: float) -> void:
	add *= scalar
	inc = inc * scalar
	mult = 1 + (mult - 1) * scalar
