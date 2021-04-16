extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spin = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-lerp(0,spin,event.relative.x/10))
