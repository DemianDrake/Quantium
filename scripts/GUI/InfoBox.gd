extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("Timer")
onready var reset = get_node("Reset")

export var end_time = 0.2
export var start_time = 0.4

var started = false
var starting = false
var action_map = {'Interactable':'interact', 'Item':'pickup'}
var duration_map = {'Interactable':'Press', 'Item':'Hold'}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(text: String, group: String):
	set_text(text)
	set_button(group)
	if started:
		show_text()
		reset.stop()
		timer.start(end_time)
	elif not starting:
		starting = true
		timer.start(start_time)


func set_text(text: String):
	get_node("ColorRect/ColorRect/Label").set_text(text)


func set_button(group: String):
	var text = duration_map[group] + ' E/X to ' + action_map[group]
	get_node("Label").set_text(text)


func show_text():
	self.set_visible(true)


func hide_text():
	self.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if started:
		hide_text()
		started = false
		starting = false
	else:
		reset.start(0.1)
		started = true
		


func _on_Reset_timeout():
	started = false
	starting = false
