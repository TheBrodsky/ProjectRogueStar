Triggers rely on duck-typing (with asserts to enforce it).
This is a list of all the implicit contracts between different trigger types.

HIT - implements signal "register_hit(body: Node2D)", where "body" is the object hit
EXPIRE - implements signal "expire(transient: Node)", where "transient" is the object that expired
PROC - implement signal "proc(procable: Node)", where "procable" is the object that procced
