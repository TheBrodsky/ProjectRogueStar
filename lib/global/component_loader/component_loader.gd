extends Node


@onready var action_list: ResourcePreloader = $ActionList
@onready var effect_list: ResourcePreloader = $EffectList
@onready var trigger_list: ResourcePreloader = $TriggerList
@onready var quant_mod_list: ResourcePreloader = $QuantModList
@onready var container_mod_list: ResourcePreloader = $ContainerModList
@onready var action_mod_list: ResourcePreloader = $ActionModList


func get_resource_list(resource_type: GlobalEnums.ActionChainResourceType) -> PackedStringArray:
	match resource_type:
		GlobalEnums.ActionChainResourceType.Action:
			return action_list.get_resource_list()
		GlobalEnums.ActionChainResourceType.Effect:
			return effect_list.get_resource_list()
		GlobalEnums.ActionChainResourceType.Trigger:
			return trigger_list.get_resource_list()
		GlobalEnums.ActionChainResourceType.QuantMod:
			return quant_mod_list.get_resource_list()
		GlobalEnums.ActionChainResourceType.ContainerMod:
			return container_mod_list.get_resource_list()
		GlobalEnums.ActionChainResourceType.ActionMod:
			return action_mod_list.get_resource_list()
		_:
			return []


func get_resource(resource_name: String, resource_type: GlobalEnums.ActionChainResourceType) -> Resource:
	match resource_type:
		GlobalEnums.ActionChainResourceType.Action:
			return action_list.get_resource(resource_name)
		GlobalEnums.ActionChainResourceType.Effect:
			return effect_list.get_resource(resource_name)
		GlobalEnums.ActionChainResourceType.Trigger:
			return trigger_list.get_resource(resource_name)
		GlobalEnums.ActionChainResourceType.QuantMod:
			return quant_mod_list.get_resource(resource_name)
		GlobalEnums.ActionChainResourceType.ContainerMod:
			return container_mod_list.get_resource(resource_name)
		GlobalEnums.ActionChainResourceType.ActionMod:
			return action_mod_list.get_resource(resource_name)
		_:
			return null
