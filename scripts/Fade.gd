extends ColorRect

signal faded

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")
	
func on_animation_finished(anim_name: String):
	emit_signal("faded")
	
func fade_in():
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	$AnimationPlayer.play("fade_out")
