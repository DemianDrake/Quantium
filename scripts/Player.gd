extends KinematicBody

# Atributos Player
const SPIN = 0.1
const SPEED = 10
const RUN_SPEED = 15
const JUMP_POWER = 20
const THROW_STRENGTH = 15
const PLAYER_GRAVITY_DEFAULT = 9.8
const GRAVITY_FACTOR = 1.6/9.8
const HOTBAR_KEYS = [KEY_1, KEY_2, KEY_3, KEY_4]

# Nodos
onready var fpc = get_node("Gimbal_h_cam_FP/Gimbal_v_cam/FP Camera")
onready var tpc = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/TP Camera")
onready var h_node = get_node("Gimbal_h_cam_FP")
onready var v_node = h_node.get_node("Gimbal_v_cam")
onready var anim_tree = get_node("Model/RotationTest/astro_player/AnimationTree")
onready var state_machine = anim_tree["parameters/playback"]

# Vars de movimiento
var vel = Vector3(0, 0, 0)
var gravity = 9.8
var up = Vector3.UP
var backward =	self.transform.basis.z.normalized()
var current_speed = SPEED
var insideArea = false
var airborne_time = 0

onready var angulo = 0
onready var axis = (Vector3.UP + Vector3(0.001,0,0)).normalized()
onready var has_floor = true
onready var inventory = hotbar_dict()

# AnimationTree
var anim_state = "Idle"
#const ESTADOS = ["Idle","Walking","Running","Jumping","Landing","Interact","PickUp1","PickUp2","Holding Idle","Floating","Dancing"]

# Raycasts y Areas
onready var downRC = get_node("downRC")
onready var FPmiddleRC = get_node("Gimbal_h_cam_FP/Gimbal_v_cam/FP RC")
onready var TPmiddleRC = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/TP RC")
onready var AreaDetector = get_node("Area")

# Controllers
var E_hold = 0
const HOLD_TIME = 0.3 # Tiempo en segundos para que se considere mantener presionado
var Click_Hold = 0
const MAX_CLICK_HOLD_TIME = 2.0

# Extra
const FLOAT_EPSILON = 1e-5

# Variables de cámara
var tpcamera = true #false: FP, true: TP
var changecamerakey = KEY_F

# Variables de interacción
var holding_item = false
var held_item = null

# VARIABLES EXPERIMENTALES
var floating = false

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
			set_anim("Dying")
#			get_tree().reload_current_scene()
		elif event.pressed and event.scancode == KEY_Y:
			OS.window_fullscreen = not OS.window_fullscreen
		elif event.pressed and event.scancode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif event.pressed and event.scancode in HOTBAR_KEYS:
			hotbar_input_handler(event.scancode)


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
	
	if on_floor and Input.is_action_pressed("run"):
		current_speed = RUN_SPEED
		anim_state = "Running"
	else:
		current_speed = SPEED
		anim_state = "Walking"
	
	if dir_x == 0 and dir_z == 0:
		anim_state = "Idle"
	
#	if vel_g > 0:
#		anim_state = "Falling"
	
	if Input.is_action_just_pressed("jump") and on_floor:
		vertical_vel *= JUMP_POWER
		anim_state = "Jumping"
	else:
		vertical_vel *= 0
	
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
	backward = v_node.transform.basis.z.normalized()
	var y_comp = backward.y * Vector3.UP
	var x_cam = h_node.transform.basis.x #* dir_x
	var z_cam = h_node.transform.basis.z #* dir_z
	var x_comp = self.transform.basis.x * x_cam.x + self.transform.basis.x * z_cam.x
	var z_comp = self.transform.basis.z * x_cam.z + self.transform.basis.z * z_cam.z
	backward = (z_cam + y_comp).normalized()
	
	if vel.length() < 10.5:
		anim_state = "Floating_A"
	else:
		anim_state = "Floating_B"
	
	if Input.is_action_just_pressed("throw"):
		Click_Hold = 0
	elif Input.is_action_pressed("throw"):
		Click_Hold += delta
		Click_Hold = min(Click_Hold,MAX_CLICK_HOLD_TIME)
		#print(Click_Hold)
	elif Input.is_action_just_released("throw"):
		vel += backward * Click_Hold
		Click_Hold = 0
		
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
			anim_state = "Interact"
			casted_interactable.interact()


func pickup(delta):
	if Input.is_action_pressed("interact"):
		var casted_item = get_raycast_elem("Item")
		if is_instance_valid(casted_item):
			anim_state = "PickUp1"
			E_hold += delta
			print(E_hold)
			if E_hold >= HOLD_TIME:
				if not holding_item:
					casted_item.grab(self.get_node("Model/RotationTest/Placeholder"))
					held_item = casted_item
					holding_item = true
					E_hold = 0
				else:
					# TODO: Place held item to inventory
					# Place picked up item to placeholder
					pass
		else:
			E_hold = 0
	else:
		E_hold = 0

func hotbar_input_handler(key):
	if holding_item:
		store(key)
	else:
		retrieve(key)

func retrieve(key):
	var slot = inventory[key]
	
	if slot['amount'] > 0:
		var item = load('res://scenes/assets/props/'+slot['name']+'.tscn').instance()
		item.grab(self.get_node("Model/RotationTest/Placeholder"))
		
		slot['amount'] -= 1
		if slot['amount'] == 0:
			slot['name'] = 'empty'
		held_item = item
		holding_item = true
		print(inventory)


func store(key):
	var slot = inventory[key]
	var is_stored = false
	var item_name = held_item.get_item_name()
	
	if slot['name'] == 'empty':
		slot['name'] = item_name
		is_stored = true
	
	elif item_name == slot['name']:
		is_stored = true
	
	if is_stored:
		slot['amount'] += 1
		held_item.queue_free()
		held_item = null
		holding_item = false
	print(inventory)

func throw(delta):
	if not holding_item:
		return
	
	if Input.is_action_pressed("throw"):
		Click_Hold += delta
		Click_Hold = min(Click_Hold,MAX_CLICK_HOLD_TIME)
		return
	elif Input.is_action_just_released("throw"):
		#vel += backward * Click_Hold
		held_item.release()
		
		var direction = TPmiddleRC.get_global_transform().origin.direction_to(
			get_node("Gimbal_h_cam_TP/Gimbal_v_cam/RaycastPointer").get_global_transform().origin
		)
		
		#Alternativa
		#direction = -1 * get_node("Model/RotationTest").transform.basis.z;
		
		held_item.apply_central_impulse(direction.normalized() * Click_Hold * THROW_STRENGTH)
		held_item = null
		holding_item = false
#		anim_state = "Throwing"
		
		if floating:
			pass
		Click_Hold = 0
		return

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
	throw(delta)
	set_anim(anim_state)

func set_anim(state):
	state_machine.travel(state)

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

static func slot_dict():
	return {'amount':0, 'name':'empty'}

static func hotbar_dict():
	var dict = {}
	for i in HOTBAR_KEYS:
		dict[i] = slot_dict()
	return dict


#funcion de rotacion del modelo
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(-lerp(0,spin,event.relative.x/10))
