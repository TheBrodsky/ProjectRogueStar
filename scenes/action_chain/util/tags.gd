class_name Tags
extends Resource


@export_flags("physical", "elemental") var damage_types : int = 0
@export_flags("projectile", "melee", "area", "minion", "mark") var shapes : int = 0
@export_flags("hit", "DoT", "buff", "debuff", "move") var effects : int = 0
@export_flags("duration") var other_properties : int = 0


## Combines this Tags object and another Tags object by adding their flags together. Does not modify either Tags. Returns a new Tags object.
func add(other: Tags) -> Tags:
	var new_tags: Tags = Tags.new()
	new_tags.damage_types = damage_types | other.damage_types
	new_tags.shapes = shapes | other.shapes
	new_tags.effects = effects | other.effects
	new_tags.other_properties = other_properties | other.other_properties
	return new_tags


## Removes flags in "other" from this Tags object. Does not modify either Tags. Returns a new Tags object.
func subtract(other: Tags) -> Tags:
	var new_tags: Tags = Tags.new()
	new_tags.damage_types = damage_types & ~other.damage_types
	new_tags.shapes = shapes & ~other.shapes
	new_tags.effects = effects & ~other.effects
	new_tags.other_properties = other_properties & ~other.other_properties
	return new_tags
