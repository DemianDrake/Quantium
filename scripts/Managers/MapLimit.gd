extends Area

func _ready() -> void:
	var _error = connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Spatial):
	if body.is_in_group("Player"):
		LevelManager.fade_and_call_method(LevelManager, "go_to_checkpoint", body)
