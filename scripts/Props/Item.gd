extends RigidBody

# Default values
var tmp_transform = null
export var item_name = 'Empty'
export var max_amount = 10
export var scene_path = 'res://path/to/scene'
export var texture_path = 'res://path/to/image'
#export var sleeping_mode = true

# Called when the node enters the scene tree for the first time.
func _ready():
	tmp_transform = get_global_transform()
	set_sleeping(false)
	
func grab(node):
	var parent = get_parent()
	
	if is_instance_valid(parent):
		parent.remove_child(self)
	node.add_child(self)
	#set_translation(Vector3(0, 0, 0))
	set_transform(Transform.IDENTITY)
	set_physics_process(false)
	
func release():
	# tmp_node/Player/Model/RotationTest/Placeholder
	var tmp_node = get_parent().get_parent().get_parent().get_parent().get_parent()
	tmp_transform = get_global_transform()
	get_parent().remove_child(self)
	tmp_node.add_child(self)
	set_physics_process(true)
	set_global_transform(tmp_transform)

func get_item_name():
	return item_name

func get_max_amount():
	return max_amount

func item_data_to_dict(dict):
	dict['item_name'] = item_name
	dict['max_amount'] = max_amount
	dict['scene_path'] = scene_path
	dict['texture_path'] = texture_path


func set_data_from_dict(dict):
	item_name = dict['item_name']
	max_amount = dict['max_amount']
	scene_path = dict['scene_path']
	texture_path = dict['texture_path']

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass