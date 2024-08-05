extends Follower


## SnakeAt will continually modify the flight-path of the parent entity to move in a sin-wave "snake" fashion.

@export var amplitude: float = 1 ## max distance from center (small changes go a long way)
@export var frequency: float = TAU ## number of oscillations per second 
var x : float = 0 #used to track current progress along snake
var speed_multiplier: float #how much we should speed up the projectile so it moves toward the target at the speed before snake_at was applied
var parent_direction: Vector2

func _ready() -> void:
	super()
	parent_direction = MovementTools.calcDirectionFromAngle(parent_entity.rotation)


func _process(delta: float) -> void:
	x += delta 
	_apply_movement(delta, _get_direction_vector())


func _modify_from_state(state: ActionState) -> void:
	super(state)
	amplitude = state.get_snaking_amplitude()
	frequency = state.get_snaking_frequency()
	speed_multiplier = sqrt(1 + (pow(PI,2)*pow(amplitude,2)*pow(frequency,2))) #Perplexity's formula go brrrr

	speed *= speed_multiplier

func _calc_move_vector(delta: float, direction: Vector2) -> Vector2: 
	var rotation_vector: Vector2 = _calc_direction_along_snake(delta, direction)
	#need a way to set the parent direction to desired point - the point in the "center of mass" of the snake motion
	#if we want it to work with other movement options like orbit and home
	parent_direction = MovementTools.calcDirectionFromAngle(parent_entity.rotation)
	return MovementTools.calcMoveVector(rotation_vector, speed, delta)

func _calc_direction_along_snake(delta: float, direction: Vector2) -> Vector2:
	#given an "x" (amount along our sine wave), calculate the direction to go next
	#y=amplitude*sin(x*frequency) #function we want to follow
	var y: float = 0
	if (frequency > .01): #currently no projectile emmited when frequency == 0
		y = amplitude*(TAU*frequency)*cos(x*TAU*frequency) # x = time since start
	#y is a slope, but we need a Vector2
	var perpendicular_direction: Vector2 = Vector2(parent_direction.y * -1, parent_direction.x)
	perpendicular_direction = perpendicular_direction*y #scale by y
	return parent_direction + perpendicular_direction 
