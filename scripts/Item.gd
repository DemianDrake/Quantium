extends RigidBody


# Default values
var tmp_transform = null


# Called when the node enters the scene tree for the first time.
func _ready():
	tmp_transform = get_global_transform()
	set_sleeping(true)
	
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
