extends Area

export var say_something = false
export (Array, String) var dialogues
export (String) var dialog_mode
export (Array, float) var times

export (String) var next_scene_path

func _ready():
	var _entered_signal = connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body: Node):
	if body.is_in_group("Player"):
		if say_something:
			yield(get_tree().create_timer(times[0]), "timeout")
			body.comment(dialogues, dialog_mode, times)
			yield(get_tree().create_timer(times[0]), "timeout")
		LevelManager.clean_checkpoints()
		LevelManager.fade_and_call_method(LevelManager, "change_scene", next_scene_path)
