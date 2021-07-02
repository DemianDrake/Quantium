extends Spatial

export (bool) var this_bool
export (Array, NodePath) var targets_path
export (Array, NodePath) var previous_path
export (Array, bool) var expected_state
var targets = []
var previous = []
var bools = []

func _ready() -> void:
	for path in targets_path:
		targets += [get_node(path)]
	for path in previous_path:
		previous += [get_node(path)]
		bools += [false]

func next_step(mode):
	# Checkear cada uno de los booleanos
	for i in previous.size():
		if "this_bool" in previous[i]:
			bools[i] = previous[i].this_bool == expected_state[i]
		else:
			print("node " + previous[i].get_name() + " is not a logic node!")
	# Comprobación final
	if !bools.has(false):
		for target in targets:
			target.button_pressed(mode)
