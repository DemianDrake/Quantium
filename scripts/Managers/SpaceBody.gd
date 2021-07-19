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


func _on_NewGame_pressed() -> void:
	LevelManager.next()
	LevelManager.Game.music.stop()

func _on_LoadGame_pressed() -> void:
	pass # Replace with function body.

func _on_Credits_pressed() -> void:
	# Transición a créditos
	$Camera/AnimationPlayer.play("CameraCredits", -1, 0.5)
	yield(get_tree().create_timer(2), "timeout")
	$AnimationPlayer.play("Credits")
	yield($Camera/AnimationPlayer, "animation_finished")
	# En créditos
	$CanvasLayer/Tween.interpolate_property($CanvasLayer/CreditsUI, "rect_position", Vector2(0,0), Vector2(0,-1000), 9.5, Tween.TRANS_LINEAR)
	$CanvasLayer/Tween.start()
	yield(get_tree().create_timer(10), "timeout")
	# Vuelta a menú principal
	$Camera/AnimationPlayer.play("CameraCredits", -1, -0.5, true)
	yield(get_tree().create_timer(1.5), "timeout")
	$AnimationPlayer.play("Credits", -1, -1.0, true)
	yield($Camera/AnimationPlayer, "animation_finished")
	$CanvasLayer/CreditsUI.rect_position.y = 0
	get_node("CanvasLayer/MainMenuGUI/VBoxContainer/Button/NewGame").grab_focus()

func _on_Exit_pressed() -> void:
	LevelManager.Game.fade.fade_in()
	yield(LevelManager.Game.fade, "faded")
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
