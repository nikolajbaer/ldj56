extends Node3D

var Egg = preload("res://egg.tscn")
var Creature = preload("res://creature.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("boat_enter")
	$Boat.connect("full",_on_full)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
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
	critter.target_radius = 1
	critter.connect("chomp",_on_chomp)
	add_child(critter)
	
func _on_chomp():
	$trampoline.weighed_down += 1

#func _input(event):
	#if event.is_action_pressed("ui_cancel"):
		#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "boat_enter":
		$AnimationPlayer.play("boat_rock",-3)
	elif anim_name == "boat_exit":
		$Boat.clear_cargo()
		$AnimationPlayer.play("boat_enter")

func _on_full():
	$AnimationPlayer.play("boat_exit",-2)
