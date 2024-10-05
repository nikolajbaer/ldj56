extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 4.5

var target:Node3D
func _ready():
	$AnimationPlayer.current_animation = "chomp"
	$AnimationPlayer.play()

func _physics_process(delta: float) -> void:
	#under water
	if position.y < -2:
		print("creature ",name," sank")
		self.queue_free()
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if randf() < 0.01:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var dir = Vector3(0,0,0)
	var target_same_plane = Vector3(target.position.x,self.position.y,target.position.z)
	if target:
		var dist_to = target_same_plane - self.position
		if dist_to.length() > 5:
			dir = dist_to
			self.look_at(target_same_plane)
	if dir.length():
		var direction := (transform.basis * Vector3(dir.x, 0, dir.z)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
