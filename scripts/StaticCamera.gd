extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const THISKEY = KEY_4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == THISKEY:
			self.make_current()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
