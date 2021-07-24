extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("Timer")
onready var speaker_label = get_node("ColorRect2/ColorRect/Label")

var text_array
var mode
var index = 0
var over = false
var time_array

# Called when the node enters the scene tree for the first time.
func _ready():
	var _error = Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	if len(Input.get_connected_joypads()) > 0:
		$ColorRect/Control/A.show()
		$ColorRect/Control/Space.hide()
	var _fade  = $Fade.connect("tween_completed", self, "_on_faded")
	$Fade.interpolate_property($ColorRect/Control, "modulate:a",
								$ColorRect/Control.modulate.a, 1.0 - $ColorRect/Control.modulate.a,
								1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)


func setup(dialogues: Array, dialog_mode: String, times: Array, speaker: String):
	reset()
	set_dialogues(dialogues)
	set_times(times)
	set_mode(dialog_mode)
	set_speaker(speaker)
	show_text()
	if self.mode == 'AUTO':
		$ColorRect/Control.hide()
		wait()
	elif self.mode == 'MANUAL':
		$ColorRect/Control.show()
		$Fade.start()
		get_tree().paused = true
	next()


func set_mode(dialog_mode: String):
	self.mode = dialog_mode


func set_speaker(speaker: String):
	self.speaker_label.set_text(speaker)


func set_times(times: Array):
	self.time_array = times


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
	self.timer.start(self.time_array[index])


func next():
	self.index += 1


func reset():
	self.index = 0
	self.over = false


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


func _on_faded(_object, _key):
	$Fade.interpolate_property($ColorRect/Control, "modulate:a",
								$ColorRect/Control.modulate.a, 1.0 - $ColorRect/Control.modulate.a,
								1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Fade.start()


func _on_joy_connection_changed(_device_id, connected):
	if connected:
		$ColorRect/Control/A.show()
		$ColorRect/Control/Space.hide()
	else:
		$ColorRect/Control/A.hide()
		$ColorRect/Control/Space.show()


func _on_Timer_timeout():
	if self.index < len(text_array):
		show_text()
		wait()
		next()
	else:
		hide_text()
