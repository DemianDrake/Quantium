extends Node

onready var Game = get_tree().get_root().get_node("Game")

var start_position: Vector3

var checkpoint: Node setget set_checkpoint
func set_checkpoint(value):
	if checkpoint:
		checkpoint.off()
	checkpoint = value
	checkpoint.on()

func go_to_checkpoint(node: Spatial):
	var new_position 
	if checkpoint:
		new_position = checkpoint.get_spawn_point()
	elif start_position:
		new_position = start_position
	if new_position:
		node.teleport(new_position)
		node.add_hp(node.MAX_HEALTH)
		node.add_o2(node.MAX_O2)
		node.dying = false

func next():
	Game.next()  

func change_scene(scene):
	Game.change_scene(scene)

func reset():
	Game.reset()

func add_scene(scene):
	Game.add_scene(scene)

func remove_scene(scene_node):
	Game.remove_scene(scene_node)

func fade_and_call_method(target: Node, method: String, arg):
	Game.fade.fade_in()
	yield(Game.fade, "faded")
	target.call(method, arg)
	Game.fade.fade_out()

