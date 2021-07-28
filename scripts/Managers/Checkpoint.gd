extends Area

export (NodePath) var room_nodepath
export (String) var room_resource
export var room_resetable = false
var inventory
var room_node
var room

func _ready() -> void:
	var _entered_signal = connect("body_entered", self, "on_body_entered")
	if room_resetable:
		room_node = get_node(room_nodepath)
		room = load(room_resource)

func on_body_entered(body: Node):
	if body.is_in_group("Player"):
		body.show_save_icon()
		self.inventory = body.get_inventory().duplicate(true)
		LevelManager.checkpoint = self

func on():
	$CollisionShape.set_deferred("disabled", true)
#	print_debug("%s is on" % name)

func off():
	$CollisionShape.set_deferred("disabled", false)
#	print("%s is off" % name)

func get_spawn_point():
	return $Spawn.global_transform.origin
