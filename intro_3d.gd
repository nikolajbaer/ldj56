extends Node3D

var Egg = preload("res://egg.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()
	$trampoline.active =  false
	$Boat.connect('full',_on_full)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_full():
	$Boat.clear_cargo()

func _on_timer_timeout() -> void:
	var egg = Egg.instantiate()
	egg.position.x = 2.2
	egg.position.y = 20
	add_child(egg)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://root.tscn")
