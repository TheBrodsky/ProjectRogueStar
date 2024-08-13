extends Resource
class_name FloatStat


static func get_stat() -> FloatStat:
	var stat: FloatStat = FloatStat.new()
	stat.resource_local_to_scene = true
	return stat


@export var add: float = 0
@export var inc: float = 1
@export var mult: float = 1


func val() -> float:
	return add * inc * mult


func merge(other: FloatStat) -> void:
	add += other.add
	inc += other.inc
	mult *= other.mult


func scale(scalar: float) -> void:
	add *= scalar
	inc = (inc - 1) * scalar
	mult = (mult - 1) * scalar
