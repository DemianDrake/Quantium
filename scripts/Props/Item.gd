extends RigidBody

# Default values
var tmp_transform = null
export var is_duplicate = true
export var item_name = 'Empty'
export var max_amount = 10
export var scene_path = 'res://path/to/scene'
export var texture_path = 'res://path/to/image'
export var description = 'Generic description, please put something else, xoxo.'
#export var sleeping_mode = true

# Called when the node enters the scene tree for the first time.
func _ready():
	tmp_transform = get_global_transform()
	set_sleeping(false)
	connect("body_entered", self, "_on_collision") 


func grab(node):
	var parent = get_parent()
	
	if is_instance_valid(parent):
		parent.remove_child(self)
	node.add_child(self)
	
	if is_duplicate:
		self.add_to_group("Duplicated")
		
	if item_name == 'Quantium':
		self.mode = RigidBody.MODE_RIGID
	
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
	if item_name == 'Quantium':
		self.mode = RigidBody.MODE_STATIC
	

func get_item_name():
	return item_name

func get_max_amount():
	return max_amount


func get_description():
	return description


func item_data_to_dict(dict):
	dict['item_name'] = item_name
	dict['max_amount'] = max_amount
	dict['scene_path'] = scene_path
	dict['texture_path'] = texture_path
	dict['groups'] = get_groups()


func set_data_from_dict(dict):
	item_name = dict['item_name']
	max_amount = dict['max_amount']
	scene_path = dict['scene_path']
	texture_path = dict['texture_path']
	for group in dict['groups']:
		add_to_group(group)

func _on_collision(body: Node) -> void:
#	print(self.name, " collided with ", body.name)
	$CollideSound.play(0.0)
