extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5

var target:Node3D
func _ready():
	$AnimationPlayer.current_animation = "chomp"
	$AnimationPlayer.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if randf() < 0.01:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir = Vector3(0,0,0)
	if target:
		var dist_to = target.position - self.position
		if dist_to.length() > 1:
			input_dir = dist_to
	if input_dir.length():
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
