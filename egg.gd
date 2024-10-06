extends RigidBody3D
class_name Egg

signal hit_ground
@onready var timer = $Timer
const CRACK_SPEED = 6
var last_vel
var crack_triggered = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	last_vel = abs(linear_velocity.y)
	if position.y < -3:
		self.queue_free()

func _on_body_entered(body: Node) -> void:
	#print("Egg hit ",body.name," at ",last_vel)

	if body.name == "ground" and last_vel > CRACK_SPEED and not crack_triggered:
		timer.start()
		crack_triggered = true

func stow():
	self.freeze = true
	rotation = Vector3(0,0,0)

func _on_timer_timeout() -> void:
	var ground_pos = Vector3(position.x,position.y,position.z)
	hit_ground.emit(ground_pos)
	self.queue_free()
