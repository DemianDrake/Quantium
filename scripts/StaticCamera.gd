extends Camera


const THISKEY = KEY_5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == THISKEY:
			self.make_current()
