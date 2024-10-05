extends AnimatableBody3D

signal full

var egg_count = 0

func _on_catch_area_body_entered(body: Node3D) -> void:
	if body is Egg:
		body.stow()
		body.get_parent().remove_child(body)
		body.position = $EggStart.position + Vector3(egg_count%2 * 3,0,floor(egg_count/6)*3)
		add_child(body)
		egg_count += 1
		if egg_count == 12:
			full.emit()
		
