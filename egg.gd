extends RigidBody3D

signal hit_ground

const CRACK_SPEED = 6
var last_vel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	last_vel = abs(linear_velocity.y)
	if position.y < -3:
		self.queue_free()

func _on_body_entered(body: Node) -> void:
	print("Egg hit ",body.name," at ",last_vel)

	if body.name == "ground" and last_vel > CRACK_SPEED:
		var ground_pos = Vector3(position.x,0.55,position.z)
		hit_ground.emit(ground_pos)
		self.queue_free()
