extends KinematicBody

# Atributos Player
const SPIN = 0.1
const SPEED = 10
const RUN_SPEED = 15
const JUMP_POWER = 20
const THROW_STRENGTH = 30.0
const PLAYER_GRAVITY_DEFAULT = 9.8
const GRAVITY_FACTOR = 1.6/9.8
const MAX_HEALTH = 100
const MAX_O2 = 100

# Nodos
onready var fpc = get_node("Gimbal_h_cam_FP/Gimbal_v_cam/FP Camera")
onready var tpc = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/TP Camera")
onready var h_node = get_node("Gimbal_h_cam_FP")
onready var v_node = h_node.get_node("Gimbal_v_cam")
onready var anim_tree = get_node("Model/RotationTest/astro_player/AnimationTree")
onready var state_machine = anim_tree["parameters/playback"]
onready var inventory_node = get_node("CanvasLayer/InGameGUI/Hotbar/Inventory")

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
onready var FPmiddleRP = get_node("Gimbal_h_cam_FP/Gimbal_v_cam/RaycastPointer")
onready var TPmiddleRC = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/TP RC")
onready var TPmiddleRP = get_node("Gimbal_h_cam_TP/Gimbal_v_cam/RaycastPointer")
onready var AreaDetector = get_node("Area")

# Controllers
var E_hold = 0
const HOLD_TIME = 0.3 # Tiempo en segundos para que se considere mantener presionado
var Click_Hold = 1.0
const MAX_CLICK_HOLD_TIME = 1.8

# Extra
const FLOAT_EPSILON = 1e-5

# Variables de cámara
var tpcamera = true #false: FP, true: TP

# Variables de interacción
var holding_item = false
var held_item = null

# Variables UI
var current_hp = MAX_HEALTH
var current_o2 = MAX_O2

# VARIABLES EXPERIMENTALES
var floating = false
var debug_gravitometro = true
var mouse_captured

# Called when the node enters the scene tree for the first time.
func _ready():
	tpc.make_current()
	TPmiddleRC.add_exception(self)
	capture_mouse()
	mouse_captured = true
	LevelManager.start_position = get_global_transform().origin

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("change_camera"):
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
		elif event.is_action_pressed("pause"):
			release_mouse()
			$PauseMenu.toggle()

func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_R:
#			set_anim("Dying")
			LevelManager.fade_and_call_method(LevelManager, "go_to_checkpoint", self)
		elif event.pressed and event.scancode == KEY_G:
			debug_gravitometro = not debug_gravitometro
			get_tree().call_group("GravityParticles", "set_emitting", debug_gravitometro)
		# CAMBIAR FULLSCREEN CAMBIADO A _INPUT DE GAME.GD
#		elif event.pressed and event.scancode == KEY_Y:
#			OS.window_fullscreen = not OS.window_fullscreen

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
	
	var horizontal_vel = (x_comp + z_comp).normalized()
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
	
#	var on_floor = downRC.is_colliding()
	
#	var dir_z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#var horizontal_vel2 = h_node.transform.basis.x * dir_x + h_node.transform.basis.z * dir_z
	backward = v_node.transform.basis.z.normalized()
	var y_comp = backward.y * Vector3.UP
#	var x_cam = h_node.transform.basis.x #* dir_x
	var z_cam = h_node.transform.basis.z #* dir_z
#	var x_comp = self.transform.basis.x * x_cam.x + self.transform.basis.x * z_cam.x
#	var z_comp = self.transform.basis.z * x_cam.z + self.transform.basis.z * z_cam.z
	backward = (z_cam + y_comp).normalized()
	
	if vel.length() < 10.5:
		anim_state = "Floating_A"
	else:
		anim_state = "Floating_B"
	
	if Input.is_action_just_pressed("throw"):
		Click_Hold = 1.0
	elif Input.is_action_pressed("throw"):
		Click_Hold += delta
		Click_Hold = min(Click_Hold,MAX_CLICK_HOLD_TIME)
		#print(Click_Hold)
	elif Input.is_action_just_released("throw"):
		vel += backward * Click_Hold
		Click_Hold = 1.0
		
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
	var overlapping = AreaDetector.get_overlapping_areas()
	var exists = false
	if overlapping.empty():
		exists = false
	else:
		for area in overlapping:
			if 'enabled' in area:
				if area.enabled:
					exists = true #Se está en un área con gravedad
					return
	if not exists:
		self.set_gravity(PLAYER_GRAVITY_DEFAULT)
		self.set_up_vector((Vector3.UP + Vector3(0.001,0,0)).normalized())
		self.set_floor(true)


func set_floor(new_has_floor):
	self.has_floor = new_has_floor


func set_gravity(newGravity):
	gravity = newGravity


func set_up_vector(newUpVector):
	if gravity > 0:
		up = newUpVector


func interact():
	if Input.is_action_just_pressed("interact"):
		var casted_interactable = get_raycast_elem("Interactable")
		if is_instance_valid(casted_interactable):
			if casted_interactable.is_in_group("Item"):
				if held_item == casted_interactable:
					casted_interactable.interact(self)
			else:
				anim_state = "Interact"
				casted_interactable.interact(self)
		elif is_instance_valid(held_item):
			if held_item.is_in_group("Interactable"):
				held_item.interact(self)


func pickup(delta):
	if Input.is_action_pressed("interact"):
		var casted_item = get_raycast_elem("Item")
		if is_instance_valid(casted_item):
			anim_state = "PickUp1"
			E_hold += delta
			#print(E_hold)
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


func get_slot_key():
	var key
	if Input.is_action_just_pressed("hotbar_1"):
		key = 'Slot1'
	elif Input.is_action_just_pressed("hotbar_2"):
		key = 'Slot2'
	elif Input.is_action_just_pressed("hotbar_3"):
		key = 'Slot3'
	elif Input.is_action_just_pressed("hotbar_4"):
		key = 'Slot4'
	return key


func hotbar_input_handler():
	if Input.is_action_just_pressed("hotbar_key"):
		var key = get_slot_key()
		if holding_item:
			store(key)
		else:
			retrieve(key)
		inventory_node.update_hotbar(inventory)


func retrieve(key):
	var slot = inventory[key]
	
	if slot['amount'] > 0:
		var item = load(slot['scene_path']).instance()
		item.set_data_from_dict(slot)
		item.grab(self.get_node("Model/RotationTest/Placeholder"))
		
		slot['amount'] -= 1
		if slot['amount'] == 0:
			inventory[key] = slot_dict()
		held_item = item
		holding_item = true


func can_store():
	var slot
	var store_key
	var has_space = false
	var is_stored = false
	var keys = inventory.keys()
	keys.invert()
	
	for k in keys:
		slot = inventory[k]
		if slot['item_name']=='empty':
			store_key = k
			has_space = true
		elif slot['item_name']==held_item.get_item_name():
			if slot['amount'] < held_item.get_max_amount():
				store_key = k
				has_space = true
				is_stored = true
			else:
				has_space = false
			break
	return {'store_key':store_key, 'has_space':has_space, 'is_stored':is_stored}


func store(key):
	var store_dict = can_store()
	
	if store_dict['has_space']:
		var store_key = store_dict['store_key']
		var slot = inventory[store_key]
		
		if not store_dict['is_stored']:
			held_item.item_data_to_dict(slot)
		slot['amount'] += 1
		held_item.queue_free()
		held_item = null
		holding_item = false
		
		if key != store_key:
			retrieve(key)


func throw(_delta):
	if not holding_item:
		return
	
	elif Input.is_action_just_released("throw"):
		#vel += backward * Click_Hold
		held_item.release()
		
		#Alternativa
		var direction
		if tpcamera:
			direction = TPmiddleRP.get_global_transform().origin - tpc.get_global_transform().origin
		else:
			direction = FPmiddleRP.get_global_transform().origin - fpc.get_global_transform().origin
		
		held_item.apply_central_impulse(direction.normalized() * THROW_STRENGTH)
		held_item = null
		holding_item = false
#		anim_state = "Throwing"
		
		if floating:
			pass
		return
	
	elif Input.is_action_just_released("release"):
		#vel += backward * Click_Hold
		held_item.release()
		
		held_item = null
		holding_item = false
#		anim_state = "Throwing"
		
		if floating:
			pass
		return


func get_o2_depletion_rate(delta):
	var rate = delta
	if Input.is_action_pressed("run"):
		rate *= 2
	return rate


func add_o2(amount):
	self.current_o2 += amount
	self.current_o2 = clamp(self.current_o2, 0, MAX_O2)


func decrease_o2(amount):
	add_o2(-amount)


func updateO2(delta):
	var rate = get_o2_depletion_rate(delta)
	if current_o2 > 0:
		decrease_o2(rate)
	else:
		decrease_hp(10*rate)


func add_hp(amount):
	self.current_hp += amount
	self.current_hp = clamp(self.current_hp, 0, MAX_HEALTH)


func decrease_hp(amount):
	add_hp(-amount)


func update_bars(delta):
	updateO2(delta)
	get_node("CanvasLayer/InGameGUI/Bar/HP").update_bar(current_hp/MAX_HEALTH)
	get_node("CanvasLayer/InGameGUI/Bar/O2").update_bar(current_o2/MAX_O2)


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
	hotbar_input_handler()
	pickup(delta)
	throw(delta)
	update_bars(delta)
	set_anim(anim_state)


func set_anim(state):
	state_machine.travel(state)


func get_inventory():
	return inventory

func teleport(new_pos):
	global_transform.origin = new_pos

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	mouse_captured = false

static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon


static func slot_dict():
	return {'amount':0, 'item_name':'empty', 'max_amount':0, 'scene_path':'', 'texture_path':''}


static func hotbar_dict():
	var dict = {}
	for i in range(1,5):
		dict['Slot' + str(i)] = slot_dict()
	return dict


#funcion de rotacion del modelo
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#rotate_y(-lerp(0,spin,event.relative.x/10))
