extends Spatial

var Levels = {
	"Main" : preload("res://scenes/Main.tscn"),
	"Intro" : preload("res://scenes/GUI/cutscenes.tscn"),
	"Tutorial" : preload("res://scenes/rooms/tutorial/tutorial.tscn"),
	"Tutorial_2" : preload("res://scenes/rooms/tutorial/tutorial_2.tscn"),
	"Final_level" : preload("res://scenes/rooms/levels/room_5.tscn")
	}

var Level_names = [
	"Main",
	"Intro",
	"Tutorial",
	"Tutorial_2",
	"Final_level"
	]

var current_level = 0
var current_world: Node = null
var loading = false

onready var fade = $CanvasLayer/Fade
onready var music= $Music
onready var sfx  = $Sfx

func _ready():
	fade.connect("faded", self, "on_faded")
	current_world = Levels[Level_names[0]].instance()
	$World.add_child(current_world)
	music.stream = AudioManager.play()
	music.play()
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("toggle_fullscreen"):
			OS.window_fullscreen = not OS.window_fullscreen


func change_scene(scene):
	var s = load(scene).instance()
	$World.remove_child(current_world)
	current_world.queue_free()
	current_world = s
	$World.add_child(current_world)

func add_scene(scene):
	get_tree().paused = true
	fade.fade_in()
	yield(fade, "faded")
	var s = load(scene).instance()
	$World.add_child(s)
	fade.fade_out()

func remove_scene(scene_node):
	
	fade.fade_in()
	yield(fade, "faded")
	$World.remove_child(scene_node)
	scene_node.queue_free()
	fade.fade_out()
	get_tree().paused = false
 
func next():
	if current_level + 1 >= Levels.size():
		return
	loading = true
	fade.fade_in()


func on_faded():
	if loading:
		$World.remove_child(current_world)
		current_world.queue_free()
		current_level += 1
		current_world = Levels[Level_names[current_level]].instance()
		$World.add_child(current_world)
		loading = false
		fade.fade_out()
		
func reset():
	current_level = -1
	loading = true
	fade.fade_in()

func music_fade_out(duration):
	$Music/Tween.interpolate_property(music, "volume_db", music.volume_db, -1000, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Music/Tween.start()

func music_fade_in(duration):
	$Music/Tween.interpolate_property(music, "volume_db", music.volume_db, 0, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Music/Tween.start()

func music_fade_and_change(duration: float, new_song: int):
	music_fade_out(duration)
	yield($Music/Tween, "tween_completed")
	music.stop()
	var song = AudioManager.seek(new_song)
	music.stream = song
	music.play()
	music_fade_in(duration)
