extends AnimatableBody3D

signal full
signal egg_collected

const FULL = 12
const EGG_WIDTH=0.6
var egg_count = 0

func _on_catch_area_body_entered(body: Node3D) -> void:
	if body is Egg and not body.freeze:
		body.stow()
		body.reparent(self)
		body.position = $EggStart.position + Vector3(egg_count%2 * EGG_WIDTH,0,floor(egg_count/2)*EGG_WIDTH)
		egg_count += 1
		egg_collected.emit()
		if egg_count == FULL:
			full.emit()
			$"Win-kaching".play()
		else:
			$Caching.play()
		
func clear_cargo():
	for child in get_children():
		if child is Egg:
			child.queue_free()
	egg_count = 0
