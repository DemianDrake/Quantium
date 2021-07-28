extends Spatial

export var is_ready = false
export (String) var ready_anim
export (String) var moving_anim

func button_pressed(forward):
	if not is_ready:
		$AnimationPlayer.play(ready_anim)
		is_ready = true
	else:
		var speed = 1.0 if forward else -1.0
		$AnimationPlayer.play(moving_anim, 0.5, speed, not forward)
