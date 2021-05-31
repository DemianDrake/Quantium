extends KinematicBody

# Atributos Player
const SPIN = 0.1
const SPEED = 10
const RUN_SPEED = 15
const JUMP_POWER = 20
const PLAYER_GRAVITY_DEFAULT = 9.8
const GRAVITY_FACTOR = 1.6/9.8

# Vars de movimiento
var vel = Vector3(0, 0, 0)
var gravity = 9.8
var up = Vector3.UP
var current_speed = SPEED
var insideArea = false
var airborne_time = 0

onready var angulo = 0
onready var axis = (Vector3.UP + Vector3(0.001,0,0)).normalized()
onready var has_floor = true

# Raycasts y Areas
onready var downRC = get_node("downRC")
onready var FPmiddleRC = get_node("Gimbal_h_cam_FP/Gimbal_v_cam/FP RC")
onready var TPmiddleRC = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/TP RC")
onready var AreaDetector = get_node("Area")

# Controllers
var E_hold = 0
const HOLD_TIME = 0.3 # Tiempo en segundos para que se considere mantener presionado
var Click_Hold = 1
const MAX_CLICK_HOLD_TIME = 2.0

# Extra
const FLOAT_EPSILON = 1e-5

# Variables de cámara
var tpcamera = true #false: FP, true: TP
var changecamerakey = KEY_F

onready var fpc = get_node("Gimbal_h_cam_FP/Gimbal_v_cam/FP Camera")
onready var tpc = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/TP Camera")
onready var h_node = get_node("Gimbal_h_cam_FP")
onready var v_node = h_node.get_node("Gimbal_v_cam")

# Called when the node enters the scene tree for the first time.
func _ready():
	tpc.make_current()
	TPmiddleRC.add_exception(self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == changecamerakey:
			if tpcamera:
				tpcamera = false
				fpc.make_current()
				h_node = get_node("Gimbal_h_cam_FP")
				v_node = h_node.get_node("Gimbal_v_cam")
			else:
				tpcamera = true
				tpc.make_current()
				h_node = get_node("Gimbal_h_cam_TP")
				v_node = h_node.get_node("Gimbal_v_cam")
		elif event.pressed and event.scancode == KEY_R:
			get_tree().reload_current_scene()
		elif event.pressed and event.scancode == KEY_Y:
			OS.window_fullscreen = not OS.window_fullscreen
		elif event.pressed and event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func ongrav_movement(delta):
	vel = move_and_slide(vel, up)
	var vel_g = gravity*GRAVITY_FACTOR*up*airborne_time #+ gravity*GRAVITY_FACTOR*up
	
	var on_floor = downRC.is_colliding()
	
	var dir_z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	var x_cam = h_node.transform.basis.x * dir_x
	var z_cam = h_node.transform.basis.z * dir_z
	var x_comp = self.transform.basis.x * x_cam.x + self.transform.basis.x * z_cam.x
	var z_comp = self.transform.basis.z * x_cam.z + self.transform.basis.z * z_cam.z
	
	var horizontal_vel = x_comp + z_comp
	var vertical_vel = up.normalized()
	
	if Input.is_action_just_pressed("jump") and on_floor:
		vertical_vel *= JUMP_POWER
	else:
		vertical_vel *= 0
	
	if on_floor and Input.is_action_pressed("run"):
		current_speed = RUN_SPEED
	else:
		current_speed = SPEED
	
	if on_floor:
		horizontal_vel = lerp(vel, horizontal_vel * current_speed, 0.4)
		airborne_time = 0
	else:
		horizontal_vel = lerp(vel, horizontal_vel * current_speed, 0.1)
		airborne_time += delta
		
	vel = horizontal_vel + vertical_vel - vel_g
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		var horizontal_dir = horizontal_vel - horizontal_vel.project(up*15)
		horizontal_dir = self.transform.basis.xform_inv(horizontal_dir)
		horizontal_dir = to_global(horizontal_dir.normalized())
		self.get_node("Model/RotationTest").look_at(horizontal_dir, up)


func nograv_movement(delta):
	vel = move_and_slide(vel, up)
	
	var on_floor = downRC.is_colliding()
	
	var dir_z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#var horizontal_vel2 = h_node.transform.basis.x * dir_x + h_node.transform.basis.z * dir_z
	var backward = v_node.transform.basis.z.normalized()
	var y_comp = backward.y * Vector3.UP
	var x_cam = h_node.transform.basis.x #* dir_x
	var z_cam = h_node.transform.basis.z #* dir_z
	var x_comp = self.transform.basis.x * x_cam.x + self.transform.basis.x * z_cam.x
	var z_comp = self.transform.basis.z * x_cam.z + self.transform.basis.z * z_cam.z
	backward = (z_cam + y_comp).normalized()
	
	if Input.is_action_just_pressed("throw"):
		Click_Hold = 1
	elif Input.is_action_pressed("throw"):
		Click_Hold += delta
		Click_Hold = min(Click_Hold,MAX_CLICK_HOLD_TIME)
		#print(Click_Hold)
	elif Input.is_action_just_released("throw"):
		vel += backward * Click_Hold
		Click_Hold = 1
	
	#print(h_node.transform.basis.x)
	#if horizontal_vel.length() > 0:
	#	print(horizontal_vel, horizontal_vel2)
	
	var vertical_vel = up.normalized()
	
	#if Input.is_action_just_pressed("jump") and on_floor:
	#	vertical_vel *= JUMP_POWER
	#else:
	vertical_vel *= 0
		
	vel += vertical_vel


func ongrav_rotation_quat(_delta):
	var basisQuat = Quat(self.transform.basis)
	var rotBasisQuat = Quat(self.transform.basis.rotated(axis,angulo))
	basisQuat = basisQuat.slerp(rotBasisQuat, 0.1)
	self.transform.basis = Basis(basisQuat)


func get_raycast_elem(group):
	if not tpcamera and FPmiddleRC.is_colliding():
		var obj = FPmiddleRC.get_collider()
		if obj.is_in_group(group):
			return obj
	if tpcamera and TPmiddleRC.is_colliding():
		var obj = TPmiddleRC.get_collider()
		if obj.is_in_group(group):
			return obj


func gravity_area_detector():
	if AreaDetector.get_overlapping_areas().empty():
		#print("Nadap")
		self.set_gravity(PLAYER_GRAVITY_DEFAULT)
		self.set_up_vector((Vector3.UP + Vector3(0.001,0,0)).normalized())
		self.set_floor(true)
	else:
		#print("Area")
		pass


func set_floor(has_floor):
	self.has_floor = has_floor


func set_gravity(newGravity):
	gravity = newGravity


func set_up_vector(newUpVector):
	if gravity > 0:
		up = newUpVector


func interact():
	if Input.is_action_just_pressed("interact"):
		var casted_interactable = get_raycast_elem("Interactable")
		if is_instance_valid(casted_interactable):
			casted_interactable.interact()


func pickup(delta):
	if Input.is_action_pressed("interact"):
		var casted_item = get_raycast_elem("Item")
		if is_instance_valid(casted_item):
			E_hold += delta
			print(E_hold)
			if E_hold >= HOLD_TIME:
				print("Item should be picked up now")
				casted_item.queue_free()
				E_hold = 0
		else:
			E_hold = 0
	else:
		E_hold = 0


func _physics_process(delta):
	angulo = self.transform.basis.y.angle_to(up)
	if not compare_floats(angulo, 0):
		axis = self.transform.basis.y.cross(up).normalized()
	if gravity > 0:
		ongrav_movement(delta)
		if has_floor:
			ongrav_rotation_quat(delta)
	else:
		nograv_movement(delta)
	gravity_area_detector()


func _process(delta):
	interact()
	pickup(delta)

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon


#funcion de rotacion del modelo
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(-lerp(0,spin,event.relative.x/10))
