extends Area

export (Array, String) var dialogue

func _ready():
	var _entered_signal = connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node):
	if body.is_in_group("Player"):
		body.temporal_gravitometer(3)
		body.comment(dialogue)
