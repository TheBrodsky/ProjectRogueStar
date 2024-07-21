extends QualitativeModifier
class_name ContainerModifier


## ContainerModifiers modify EventContainers.
## As a QualitativeModifier, ContainerModifiers change the behavior of EventContainers in a way
## which is not strictly numerical. Since Containers are both persistent entities and
## typically require a great deal of setup, ContainerModifiers may consist of a procedural
## modification to a Container's setup routine, a persistent behavioral modification to Container
## over the course of its lifetime, or perhaps even both. Instead of breaking these distinctions
## into different types, a ContainerModifier which only wishes to modifier some but not all
## of the possible aspects of a Container's functionality should just leave the relevant
## methods in their default, non-modifying states.


func modify_initialization(state: ActionState, container: EventContainer) -> void:
	pass


## Some Container modifications happen on the Actions within those Containers.
## The distinction between this and an ActionModifier is that this modification depends on information only the Container knows.
func modify_action(state: ActionState, container: EventContainer, action: Node2D, action_index: int) -> void:
	pass
