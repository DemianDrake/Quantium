extends Spatial

# variables
export(Array, NodePath) var targets_path
export var items_needed = 1
onready var tween = $BaseButton/Button/Tween
onready var off_position = $BaseButton/Button.get_translation() # Off
onready var  on_position = off_position - Vector3(0,0.1,0)      # On
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
			tween.interpolate_property($BaseButton/Button, "translation", off_position, on_position, 0.5, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			tween.start()
			for target in targets:
				target.button_pressed(pressed)

func on_body_exited(body: Node):
	bodies.erase(body)

