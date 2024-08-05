When designing interfaces/contracts between classes of objects, there are times
where neither inheritance nor composition are appropriate. In these cases,
we'd like to use mixins or a more classical understanding interfaces, but
GDScript implements neither. Accordingly, we have to fall back on "Duck Typing."

"Duck Typing" is a kind of implicit typing where the type of an object is inferred
by it's behavior. The saying goes: "if it walks like a duck and quacks like a duck,
it's a duck." Duck Typing has no inherent enforcement like static typing or interfaces,
and it has no guarantees like inheritance and composition. Thus, it's important that
developers have a good understanding of what defines a duck-typed object.

To that end, this "DuckTypes" directory contains scripts that essentially act as
unused interfaces. They tell you, the developer, what kinds of methods and properties
must be implemented by the implementing class in order for it to be considered
a certain type.
