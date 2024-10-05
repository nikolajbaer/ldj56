extends CharacterBody3D

signal chomp(position)

const SPEED = 1.0
const JUMP_VELOCITY = 4.5

var target:Node3D
var target_radius:float
var chomped:bool
var chomp_offset:Vector3

func _ready():
	$AnimationPlayer.current_animation = "chomp"
	$AnimationPlayer.play()
	chomped = false

func _physics_process(delta: float) -> void:
	if chomped:
		var chomp_pos = chomp_offset + target.position
		position.x = chomp_pos.x
		position.z = chomp_pos.z
		look_at(target.position)
		return
		
	#under water
	if position.y < -2:
		print("creature ",name," sank")
		self.queue_free()
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# random cute little hop
		if randf() < 0.01:
			velocity.y = JUMP_VELOCITY

	# look at our target at the same Y-plane
	var target_same_plane = Vector3(target.position.x,self.position.y,target.position.z)
	self.look_at(target_same_plane)
	var dist_to = target_same_plane - self.position
	
	if dist_to.length() < target_radius+0.2 and position.y < 1:
		print("CHOMP!")
		chomp.emit(position)
		chomped = true
		$AnimationPlayer.seek(0)
		$AnimationPlayer.stop()
		chomp_offset = position - target.position
		
	var direction := -transform.basis.z.normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	move_and_slide()
