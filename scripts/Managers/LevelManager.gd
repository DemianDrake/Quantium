extends Node

onready var Game = get_tree().get_root().get_node("Game")

var start_position: Vector3

var checkpoint: Node setget set_checkpoint
func set_checkpoint(value):
	checkpoint = value
	checkpoint.on()

func go_to_checkpoint(node: Spatial):
	var new_position 
	if checkpoint:
		new_position = checkpoint.get_spawn_point()
		var inventory = checkpoint.inventory
		node.set_inventory(inventory)
		node.gui.update_hotbar(inventory)
		get_tree().call_group("Duplicated", "queue_free")
		node.held_item = null
		node.holding_item = false
		node.airborne_time = 0
		if checkpoint.room_resetable:
			var room_node = checkpoint.room_node
			var room_transform = room_node.global_transform
			var room_parent = room_node.get_parent()
			room_node.queue_free()
			var new_room = checkpoint.room.instance()
			new_room.global_transform = room_transform
			room_parent.add_child(new_room)
			checkpoint.room_node = new_room
	elif start_position:
		new_position = start_position
	if new_position:
		node.teleport(new_position)
		node.current_hp = node.MAX_HEALTH
		node.current_o2 = node.MAX_O2
		node.dying = false

func clean_checkpoints():
	checkpoint = null

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

