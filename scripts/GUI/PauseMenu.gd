extends CanvasLayer

onready var player = get_parent()

func _ready() -> void:
	var _button1connection = $PauseMenu/VBoxContainer/Button/Resume.connect("pressed", self, "_on_resume_pressed")
	var _button2connection = $PauseMenu/VBoxContainer/Button2/Retry.connect("pressed", self, "_on_retry_pressed")
	var _button3connection = $PauseMenu/VBoxContainer/Button_3/Exit.connect("pressed", self, "_on_exit_pressed")

func button_sfx():
	LevelManager.Game.sfx.stream = AudioManager.get_sfx('click')
	LevelManager.Game.sfx.play()

func _on_resume_pressed():
	hide()
	button_sfx()
	player.capture_mouse()

func _on_retry_pressed():
	button_sfx()
	player.capture_mouse()
	LevelManager.fade_and_call_method(LevelManager, "go_to_checkpoint", player)
	hide()

func _on_exit_pressed():
	button_sfx()
	get_tree().paused = false
	LevelManager.Game.music_fade_and_change(2, 0)
	LevelManager.fade_and_call_method(LevelManager, "change_scene", "res://scenes/Main.tscn")

func show():
	$PauseMenu.show()
	get_tree().paused = true

func hide():
	$PauseMenu.hide()
	get_tree().paused = false

func toggle():
	if $PauseMenu.visible:
		hide()
	else:
		show()
		$PauseMenu/VBoxContainer/Button/Resume.grab_focus()
