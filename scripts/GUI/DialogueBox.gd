extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("Timer")
export var time = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(text: String):
	set_text(text)
	show_text()
	timer.start(time)


func set_text(text: String):
	get_node("ColorRect/ColorRect/Label").set_text(text)


func show_text():
	self.set_visible(true)


func hide_text():
	self.set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	hide_text()
