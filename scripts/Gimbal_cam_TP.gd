extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var invert_x = false
export var invert_y = false

var mouse_sensitivity = 0.005

# Called when the node enters the scene tree for the first time.
func _process(delta):
	$Gimbal_v_cam.rotation.x = clamp($Gimbal_v_cam.rotation.x, -1.4, 0.1)
	pass # Replace with function body.

#Mouse cam control
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x != 0:
			var inv = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, event.relative.x * mouse_sensitivity * inv)
		if event.relative.y != 0:
			var inv = 1 if invert_y else -1
			var rot_y = clamp(event.relative.y, -30, 30)
			$Gimbal_v_cam.rotate_object_local(Vector3.RIGHT, rot_y * mouse_sensitivity * inv)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
