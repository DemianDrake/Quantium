extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var start_timer = get_node("Start")
onready var reset_timer = get_node("Reset")
onready var end_timer = get_node("End")

export var end_time = 0.2
export var start_time = 0.4
export var reset_time = 0.1

var starting = false
var started = false

var action_map = {'Interactable':'interact', 'Item':'pickup'}
var duration_map = {'Interactable':'Press', 'Item':'Hold'}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(text: String, group: String):
	if not starting:
		start_timer.start(start_time)
		starting = true
	
	elif started:
		reset_timer.stop()
		set_text(text)
		set_button(group)
		show_text()
		end_timer.start(end_time)

func set_text(text: String):
	get_node("ColorRect/ColorRect/Label").set_text(text)


func set_button(group: String):
	var text = duration_map[group] + ' E/X to ' + action_map[group]
	get_node("Label").set_text(text)


func show_text():
	self.set_visible(true)


func hide_text():
	self.set_visible(false)


func reset():
	started = false
	starting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Reset_timeout():
	reset()


func _on_Start_timeout():
	reset_timer.start(reset_time)
	started = true


func _on_End_timeout():
	hide_text()
	reset()
