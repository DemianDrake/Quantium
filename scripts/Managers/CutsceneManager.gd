extends Control


onready var background = $Background
onready var anim_tree = $AnimationTree["parameters/playback"]
onready var alert_anim = $AlertAnim
onready var location_1 = $"Location Margin/Location 01"
onready var location_2 = $"Location Margin/Location 02"
onready var text = $"Text Boxes"
onready var logo = $GameLogo
onready var color_layer = $"Color Layer"
onready var outro = $"Outro Text"

export var current = -1
var scene = "Scene "

func _ready():
	current = LevelManager.Game.current_cutscene
	anim_tree.stop()

func set_text():
	match current:
		8:
			outro.text = "With C.R.O.N.O.S. repaired, the Quantium stabilized"
		9:
			outro.text = "I started looking for the rest of the team. When I found them, I was glad they were lucky enough to be unharmed"
		10:
			outro.text = "They were scattered all over the place, so it took a while to find all of them"
		11:
			outro.text = "But with everyone's help we managed to repair the damages caused by the incident, so that this incident would never happen again"
		12:
			outro.text = "Or so we thought"

func playscene():
	background.texture.set_current_frame(current - 1)
	scene = "Scene %d" % current
	anim_tree.travel(scene)
	if current == 5:
		alert_anim.play("Alert")
		return
	elif current >= 8:
		set_text()
	current += 1

func _process(_delta):
	if current == -1:
		return
	if anim_tree.get_current_node() == "Start":
		anim_tree.stop()
		playscene()
	elif anim_tree.get_current_node() == "Fade to White":
		alert_anim.stop()
	elif anim_tree.get_current_node() == "Ended" and current < 6:
		LevelManager.change_scene("res://scenes/rooms/tutorial/tutorial.tscn")
		LevelManager.Game.music_fade_and_change(2, 1)
		current = -1
	elif anim_tree.get_current_node() == "Ended" and current > 6:
		LevelManager.Game.music_fade_and_change(2, 0)
		LevelManager.change_scene("res://scenes/Main.tscn")
		current = -1
	if current == 6 or current == 0:
		anim_tree.start("Start")
