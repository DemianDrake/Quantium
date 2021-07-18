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

func _on_LoadGame_pressed() -> void:
	pass # Replace with function body.

func _on_Credits_pressed() -> void:
	$Camera/AnimationPlayer.play("CameraCredits", -1, 0.5)

func _on_Exit_pressed() -> void:
	LevelManager.Game.fade.fade_in()
	yield(LevelManager.Game.fade, "faded")
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
