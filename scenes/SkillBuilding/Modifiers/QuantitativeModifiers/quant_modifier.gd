@icon("res://assets/editor_icons/modifier.png")
class_name QuantitativeModifier
extends Node


## A modifier changes the behavior of something in the action chain.
## Modifiers fall under several categories, but broadly there are two: Quantative and Qualitative.
## (See QualitativeModifier for more info on them)
## Quantitative modifiers just change numbers through the ActionState. 
##
## The ActionState acts as a contract between nodes and modifiers (see ActionState for more),
## which makes Quantitative modifiers very straightforward and predictable.


func modify_state(state: ActionState) -> void:
	push_error("UNIMPLEMENTED_ERROR: Modifier.modify_state()")
