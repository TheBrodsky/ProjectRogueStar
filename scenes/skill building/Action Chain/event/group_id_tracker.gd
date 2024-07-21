extends Node
class_name GroupIdGenerator


# Ids are used to generate unique group names to keep track of emitted entities
static var _id_counter: int = 0
var _id: int


func make_group_name() -> String:
	var group_name: String = ""
	_id = _id_counter
	_id_counter += 1
	return "emission %s" % _id
