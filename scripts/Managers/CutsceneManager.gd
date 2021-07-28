extends Control


onready var background = $Background
onready var anim_tree = $AnimationTree["parameters/playback"]
onready var alert_anim = $AlertAnim
onready var location_1 = $"Location Margin/Location 01"
onready var location_2 = $"Location Margin/Location 02"
onready var text = $"Text Boxes"
onready var logo = $GameLogo
onready var color_layer = $"Color Layer"

var timer = 0.0
var current = 0
var alpha = 1.0
var scene = "Scene 0"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playscene():
	background.texture.set_current_frame(current - 1)
	scene = "Scene 0%d" % current
	anim_tree.travel(scene)
	if current == 5:
		alert_anim.play("Alert")
	current += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if anim_tree.get_current_node() == "Start":
		anim_tree.stop()
		playscene()
	elif anim_tree.get_current_node() == "Fade to White":
		alert_anim.stop()
