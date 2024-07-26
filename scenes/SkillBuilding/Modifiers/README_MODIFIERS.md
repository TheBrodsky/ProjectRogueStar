Modifiers have A LOT more responsibility than they used to.
Consequently, everything else has a lot LESS responsibility.
For example, a projectile doesn't define its own speed or movement behavior,
similar to how it doesn't define it's own effect (see Effect).


## Why Do It This Way?
This may seem cumbersome at first, but it allows modifiers to be a common API
through which all objects can define behavior. It also means there's less to
keep track of in other objects. You don't need to worry about Projectile having speed,
because it doesnt. This also means that ActionState becomes a singularly authoritative
source of information. If you want to know how fast something should move, ask
ActionState. If you want a certain projectile to move faster than other projectiles,
define a new scene for that projectile that includes a speed modifier. Only that
projectile will be faster, so only that projectile needs to know that.

Ultimately, this keeps all behavior super broken apart into neat little boxes.
Nothing is assumed about a given object or class of objects except the bare minimum.
Ideally, this makes everything very predictable. Everything does what it says on the tin;
nothing more, nothing less. And if you want to add or modify behavior, you have to
turn to modifiers to do so.


## Types of Modifiers
Modifiers are split into two broad categories: Quantitative and Qualitative.
Quantitative modifiers change numbers within the ActionState.
Qualitative modifiers change specific behavior of a class of objects, often
using a combination of an API between that modifier class and the class it modifies
and simple numeric changes akin to Quantitative modifiers.

### Modification Responsibility
Another difference between Quantitative and Qualitative modifiers is where the
responsibility of modification lies. For Quantitative modifiers, which modify
the ActionState, it is the responsibility of the modified object to modify ITSELF
according to the ActionState. For example, neither a damage modifier nor the ActionState
knows that a Damage Effect should have its damage value modified. It is the responsibility
of the Damage Effect to modify itself according to the values in the ActionState.

Qualitative modifiers, on the other hand, DO directly modify objects. This is
allowed because Qualitative modifiers have a different contract with their respective
class of objects. Container modifiers know precisely how they can modify an Event
Container, so they're able to do that.


## What Can Be Modified
At present, Modifiers can affect the following:
	- event containers
	- actions*
	- effects

Planned objects to be affected by modifiers:
	- triggers
	- events if it makes sense to do so

*Actions are a bit of a special case, because they're an informal object class.
Since basically any Node2D can be added to an Event as an "Action", it's unpredictable
how an Action will respond to modifiers. For Quantitative modifiers, this is no issue--
the object decides how to modify itself after all. For Qualitative modifiers, e.g.
Action Modifiers, this presents a problem. To solve this problem, Qualitative modifiers
only directly modify what they can gurantee (through the normal Node2D API).
Anything else checks if the action has certain properties/methods and acts accordingly.
