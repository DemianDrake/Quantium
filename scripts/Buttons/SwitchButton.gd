extends Spatial

# variables
export(Array, NodePath) var targets_path
export var items_needed = 1
onready var tween = $BaseButton/Button/Tween
onready var area  = $BaseButton/Area
var pressed = false
var targets = []
var bodies  = []
var bodies_qty:int

func _ready() -> void:
	for path in targets_path:
		targets += [get_node(path)]
	area.connect("body_entered", self, "on_body_entered")
	area.connect("body_exited" , self, "on_body_exited" )

func on_body_entered(body: Node):
	if body.is_in_group("canPressButton"):
		bodies.append(body)
		bodies_qty = len(bodies)
		if bodies_qty >= items_needed and not pressed:
			pressed = true
			for target in targets:
				target.button_pressed(pressed)

func on_body_exited(body: Node):
	bodies.erase(body)

