extends Camera

var Started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../AnimationPlayer".play("Appear")
	$AnimationPlayer.play("CameraIntro", -1, 0) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and not Started:
		$AnimationPlayer.play("CameraIntro", -1, 1)
		Started = true
		$"../AnimationPlayer".play("Transition")
