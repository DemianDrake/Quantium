extends Spatial


# Declare member variables here. Examples:
# var a = 2
export var speed = 0.05
var up = Vector3.UP


# Called when the node enters the scene tree for the first time.
func _ready():
	up = (Vector3.UP + Vector3(0.001,0,0)).normalized()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):			
	rotate_object_local(up, delta * speed)

func button_sfx():
	LevelManager.Game.sfx.stream = AudioManager.get_sfx('click')
	LevelManager.Game.sfx.play()

func _on_NewGame_pressed() -> void:
	button_sfx()
	LevelManager.change_scene("res://scenes/rooms/tutorial/tutorial.tscn")
	LevelManager.Game.music_fade_and_change(2, 1)

func _on_LoadGame_pressed() -> void:
	button_sfx()

func _on_Credits_pressed() -> void:
	button_sfx()
	# Transición a créditos
	$Camera/AnimationPlayer.play("CameraCredits", -1, 0.5)
	yield(get_tree().create_timer(2), "timeout")
	$AnimationPlayer.play("Credits")
	yield($Camera/AnimationPlayer, "animation_finished")
	# En créditos
	$CanvasLayer/Tween.interpolate_property($CanvasLayer/CreditsUI, "rect_position", Vector2(0,0), Vector2(0,-2800), 20.0, Tween.TRANS_LINEAR)
	$CanvasLayer/Tween.start()
	yield(get_tree().create_timer(21), "timeout")
	# Vuelta a menú principal
	$Camera/AnimationPlayer.play("CameraCredits", -1, -0.5, true)
	yield(get_tree().create_timer(1.5), "timeout")
	$AnimationPlayer.play("Credits", -1, -1.0, true)
	yield($Camera/AnimationPlayer, "animation_finished")
	$CanvasLayer/CreditsUI.rect_position.y = 0
	get_node("CanvasLayer/MainMenuGUI/VBoxContainer/Button/NewGame").grab_focus()

func _on_Exit_pressed() -> void:
	button_sfx()
	LevelManager.Game.fade.fade_in()
	yield(LevelManager.Game.fade, "faded")
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
