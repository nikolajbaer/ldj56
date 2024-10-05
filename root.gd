extends Node3D

var Egg = preload("res://egg.tscn")
var Creature = preload("res://creature.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var egg = Egg.instantiate()
	egg.position.x = randf_range(-5,5)
	egg.position.z = randf_range(-5,5)
	egg.position.y = 20
	egg.rotation = Vector3(randf(),randf(),randf())
	egg.connect('hit_ground',self._on_egg_hit)
	add_child(egg)

func _on_egg_hit(pos:Vector3):
	var critter =Creature.instantiate()
	critter.position = pos
	critter.target = $trampoline
	add_child(critter)
