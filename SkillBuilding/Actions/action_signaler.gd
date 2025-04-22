extends Resource
class_name ActionSignaler


## Contains all the action-chain-related signals that an action entity CAN emit.
## Not every action entity will emit all of these.
## Separating the signals out like this allows triggers to more easily connect
## to entities and allows things like statuses and effects to safely signal "through"
## their parent entity


signal has_hit(state: ActionState)
signal expired(state: ActionState)
signal procced(state: ActionState)
signal died(state: ActionState)
