@icon("res://assets/editor_icons/modifier.png")
class_name QualitativeModifier
extends Node


## A modifier changes the behavior of something in the action chain.
## Modifiers fall under several categories, but broadly there are two: Quantative and Qualitative.
## (See QuantitativeModifier for more info on them)
## Qualitative modifiers change how something behaves in a way that can't be captured through numerical changes alone.
## Oftentimes, qualitative modifiers *also* change numerical values, but only to the end of changing the behavior of something.
##
## Qualitative modifiers rely on established contracts between specific classes to change behavior.
## Hence, Qualitative modifiers further break down by the type of things they modify: Actions, Containers, etc.
## An Action modifier will have an established contract with Actions for how they should be modified.
