extends AnimatableBody3D

const SPEED = 10.0
var velocity = Vector3(0,0,0)
const MAX_DIST_FROM_ORIGIN = 6.5
var weighed_down = 0
const WEIGHT_PENALTY = 0.5
const MAX_TILT_ANGLE = 30.0

var active = true

var y_offset

#@onready var raycast = $RayCast3D

func _ready():
	y_offset = position.y

func _physics_process(delta: float) -> void:
	if not active: return
	var mouse_position = get_viewport().get_mouse_position()
	var screen_size = get_viewport().size
	var mouse_pos = (mouse_position / Vector2(screen_size)) * 2.0 - Vector2(1, 1)

	var tilt_quat = get_tilt(mouse_pos)
	
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

	var new_pos = position + velocity * delta
	#if raycast.is_colliding():
		#new_pos.y = raycast.get_collision_point().y + y_offset
	#if new_pos.length() > MAX_DIST_FROM_ORIGIN:
		#new_pos = new_pos.normalized() * (MAX_DIST_FROM_ORIGIN - 0.0001)
	
	transform = Transform3D(Basis(tilt_quat),new_pos)

# Function to tilt the platform based on a Vector2 input
func get_tilt(tilt: Vector2):
	
	# Calculate the tilt angles in radians
	var tilt_angle_x = tilt.y * MAX_TILT_ANGLE * deg_to_rad(1)  # Roll (x-axis)
	var tilt_angle_z = -tilt.x * MAX_TILT_ANGLE * deg_to_rad(1)  # Pitch (z-axis)

	# Create rotation quaternions
	var rotation_x = Quaternion(Vector3(1, 0, 0), tilt_angle_x)  # Rotate around x-axis
	var rotation_z = Quaternion(Vector3(0, 0, 1), tilt_angle_z)  # Rotate around z-axis

	# Combine rotations (apply Z tilt, then X tilt)
	var final_rotation = rotation_x * rotation_z

	# Apply the rotation, ensuring Y rotation remains at 0
	return Quaternion(Vector3(0, 1, 0), 0) * final_rotation
