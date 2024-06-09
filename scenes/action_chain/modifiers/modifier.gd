class_name Modifier
extends Node


## A modifier changes the behavior of something in the action chain, usually through the ActionState.
## For example, a modifier might increase or decrease the accuracy of a fired projectile.
## 
## Modifiers fall under 2 categories: Stat modifiers and Attachers.
## Stat modifiers inherit directly from this class. They modify stats in the ActionState.
## Attachers are modifiers for persistant entities (see IPersistant).
## They affect how an entity behaves over its lifetime and do so by "attaching" to them.


func modify_state(state: ActionState) -> void:
	push_error("UNIMPLEMENTED_ERROR: Modifier.modify_state()")
