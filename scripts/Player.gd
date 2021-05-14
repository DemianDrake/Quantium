extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spin = 0.1
var vel = Vector3(0, 0, 0)
var speed = 10
var jump_power = 40
var gravity = 9.8
var up = Vector3.UP
const gravity_factor = 1.6/9.8
var tpcamera = true #false: FP, true: TP
var changecamerakey = KEY_F

onready var fpc = get_node("Gimbal_h_cam_FP/Gimbal_v_cam/FP Camera")
onready var tpc = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/TP Camera")
onready var h_node = get_node("Gimbal_h_cam_FP")
# Called when the node enters the scene tree for the first time.
func _ready():
	tpc.make_current()

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == changecamerakey:
			if tpcamera:
				tpcamera = false
				fpc.make_current()
				h_node = get_node("Gimbal_h_cam_FP")
			else:
				tpcamera = true
				tpc.make_current()
				h_node = get_node("Gimbal_h_cam_TP")
		elif event.pressed and event.scancode == KEY_R:
			get_tree().reload_current_scene()


func _physics_process(delta):
	vel = move_and_slide(vel, up)
	vel -= gravity*gravity_factor*up
	
	var on_floor = is_on_floor()
	
	var dir_z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var horizontal_vel = h_node.transform.basis.x * dir_x + h_node.transform.basis.z * dir_z
	var vertical_vel = Vector3(0, 0, 0)
	
	if Input.is_action_just_pressed("ui_jump") and on_floor:
		vertical_vel.y = jump_power
			
	if on_floor:
		horizontal_vel = lerp(vel, horizontal_vel * speed, 0.4)
	else:
		horizontal_vel = lerp(vel, horizontal_vel * speed, 0.1)
		
	vel = horizontal_vel + vertical_vel
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#funcion de rotacion del modelo
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(-lerp(0,spin,event.relative.x/10))
