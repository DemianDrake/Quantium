extends Area

func _ready() -> void:
	var _error = connect("body_entered", self, "_on_body_entered")
	var _exited_signal  = connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body: Spatial):
	if body.is_in_group("Player"):
		body.can_fall_damage = false
		
func _on_body_exited(body: Spatial):
	if body.is_in_group("Player"):
		body.can_fall_damage = true
