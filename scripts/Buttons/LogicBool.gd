extends Spatial

export (bool) var this_bool
export (Array, NodePath) var targets_path
var targets = []

func _ready() -> void:
	for path in targets_path:
		targets += [get_node(path)]

func button_pressed(mode):
	this_bool = not this_bool
	for node in targets:
		node.next_step(mode)
