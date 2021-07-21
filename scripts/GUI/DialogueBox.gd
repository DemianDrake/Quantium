extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("Timer")
export var time = 5.0

var text_array
var mode
var index = 0
var over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(dialogues: Array, dialog_mode: String):
	reset()
	set_dialogues(dialogues)
	set_mode(dialog_mode)
	show_text()
	next()
	if self.mode == 'AUTO':
		wait()
	elif self.mode == 'MANUAL':
		get_tree().paused = true


func set_mode(dialog_mode: String):
	self.mode = dialog_mode


func set_dialogues(dialogues: Array):
	self.text_array = dialogues


func set_text(text: String):
	get_node("ColorRect/ColorRect/Label").set_text(text)


func show_text():
	set_text(text_array[index])
	self.set_visible(true)


func hide_text():
	self.set_visible(false)


func wait():
	self.timer.start(self.time)


func next():
	self.index += 1


func reset():
	self.index = 0
	self.over = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if self.mode == 'MANUAL' and event.is_action_pressed("next_dialogue"):
			if self.index < len(text_array):
				show_text()
				next()
			elif not over:
				hide_text()
				yield(get_tree(), "idle_frame")
				over = true
				get_tree().paused = false


func _on_Timer_timeout():
	if self.index < len(text_array):
		show_text()
		next()
		wait()
	else:
		hide_text()
