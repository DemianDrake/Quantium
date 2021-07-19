extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(text: String):
	set_text(text)
	show_text()
	timer.start(10)


func set_text(text: String):
	var new_text = 'Handsome Astronaut: ' + text
	get_node("ColorRect/ColorRect/Label").set_text(new_text)


func show_text():
	self.set_visible(true)


func hide_text():
	self.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	hide_text()
