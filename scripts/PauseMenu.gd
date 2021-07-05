extends CanvasLayer

onready var player = get_parent()

func _ready() -> void:
	$PauseMenu/VBoxContainer/Button/Resume.connect("pressed", self, "_on_resume_pressed")
	$PauseMenu/VBoxContainer/Button2/Retry.connect("pressed", self, "_on_retry_pressed")
	$PauseMenu/VBoxContainer/Button_3/Exit.connect("pressed", self, "_on_exit_pressed")

func _on_resume_pressed():
	hide()
	player.capture_mouse()

func _on_retry_pressed():
	player.capture_mouse()
	LevelManager.fade_and_call_method(LevelManager, "go_to_checkpoint", player)
	hide()

func _on_exit_pressed():
	get_tree().paused = false
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
