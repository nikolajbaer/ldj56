extends AnimatableBody3D

const SPEED = 10.0
var velocity = Vector3(0,0,0)
const MAX_DIST_FROM_ORIGIN = 6.5
var weighed_down = 0
const WEIGHT_PENALTY = 0.5

func _physics_process(delta: float) -> void:
	var speed = max(SPEED - (weighed_down * WEIGHT_PENALTY),1)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	position += velocity * delta
	if position.length() > MAX_DIST_FROM_ORIGIN:
		position = position.normalized() * (MAX_DIST_FROM_ORIGIN - 0.0001)
	#move_and_collide(velocity * delta)
