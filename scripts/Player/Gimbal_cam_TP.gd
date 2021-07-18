extends Spatial


export var invert_x = false
export var invert_y = false

var mouse_sensitivity = 0.005
export var controller_x_velocity = 2.5
export var controller_y_velocity = 2
const CONTROLLER_DEADZONE = 0.2


func _process(delta):
	controller_input(delta)
	$Gimbal_v_cam.rotation.x = clamp($Gimbal_v_cam.rotation.x, -1.4, 0.8)

#Mouse cam control
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x != 0:
			var inv_x = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, event.relative.x * mouse_sensitivity * inv_x)
		if event.relative.y != 0:
			var inv_y = 1 if invert_y else -1
			var rot_y = clamp(event.relative.y, -30, 30)
			$Gimbal_v_cam.rotate_object_local(Vector3.RIGHT, rot_y * mouse_sensitivity * inv_y)

#Controller cam control
func controller_input(_delta):
	var joypad_vec = Vector2()
	if Input.get_connected_joypads().size() > 0:

		if OS.get_name() == "Windows":
			joypad_vec = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
		elif OS.get_name() == "X11":
			joypad_vec = Vector2(Input.get_joy_axis(0, 3), Input.get_joy_axis(0, 4))
		elif OS.get_name() == "OSX":
			joypad_vec = Vector2(Input.get_joy_axis(0, 3), Input.get_joy_axis(0, 4))

		if joypad_vec.length() < CONTROLLER_DEADZONE:
			joypad_vec = Vector2(0, 0)
		else:
			joypad_vec = joypad_vec.normalized() * ((joypad_vec.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))

		var inv_x = 1 if invert_x else -1
		var inv_y = 1 if invert_y else -1

		$Gimbal_v_cam.rotate_object_local(Vector3.RIGHT, deg2rad(joypad_vec.y * controller_y_velocity * inv_y))

		rotate_object_local(Vector3.UP, deg2rad(joypad_vec.x * controller_x_velocity * inv_x))
