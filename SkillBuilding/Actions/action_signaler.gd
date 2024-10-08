extends Resource
class_name ActionSignaler


## Contains all the action-chain-related signals that an action entity CAN emit.
## Not every action entity will emit all of these.
## Separating the signals out like this allows triggers to more easily connect
## to entities and allows things like statuses and effects to safely signal "through"
## their parent entity


signal register_hit(state: ActionState)
signal expire(state: ActionState)
signal proc(state: ActionState)
signal die(state: ActionState)
