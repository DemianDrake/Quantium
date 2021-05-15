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

onready var angulo = 0
onready var axis = Vector3.UP

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

func ongrav_movement(delta):
	vel = move_and_slide(vel, up)
	vel -= gravity*gravity_factor*up
	
	var on_floor = is_on_floor()
	
	var dir_z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var horizontal_vel2 = h_node.transform.basis.x * dir_x + h_node.transform.basis.z * dir_z
	var x_cam = h_node.transform.basis.x * dir_x
	var z_cam = h_node.transform.basis.z * dir_z
	var x_comp = self.transform.basis.x * x_cam.x + self.transform.basis.x * z_cam.x
	var z_comp = self.transform.basis.z * x_cam.z + self.transform.basis.z * z_cam.z
	var horizontal_vel = x_comp + z_comp
	
	print(h_node.transform.basis.x)
	#if horizontal_vel.length() > 0:
	#	print(horizontal_vel, horizontal_vel2)
	
	var vertical_vel = up.normalized()
	
	if Input.is_action_just_pressed("ui_jump") and on_floor:
		vertical_vel *= jump_power
			
	if on_floor:
		horizontal_vel = lerp(vel, horizontal_vel * speed, 0.4)
	else:
		horizontal_vel = lerp(vel, horizontal_vel * speed, 0.1)
		
	vel = horizontal_vel + vertical_vel
	#vel = basisQuat.xform(vel)

func ongrav_rotation_quat(delta):
	var basisQuat = Quat(self.transform.basis)
	var rotBasisQuat = Quat(self.transform.basis.rotated(axis,angulo))
	basisQuat = basisQuat.slerp(rotBasisQuat, 0.1)
	self.transform.basis = Basis(basisQuat)
	# print(basisQuat.is_normalized())

func ongrav_rotation(delta):
	self.transform.basis = self.transform.basis.rotated(self.transform.basis.x,angulo)

func _physics_process(delta):
	angulo = self.transform.basis.y.angle_to(up)
	axis = self.transform.basis.y.cross(up).normalized()
	ongrav_movement(delta)
	ongrav_rotation_quat(delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#funcion de rotacion del modelo
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(-lerp(0,spin,event.relative.x/10))
