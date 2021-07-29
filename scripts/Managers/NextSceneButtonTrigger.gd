extends Spatial

export var change_song = false
export var say_something = false
export (Array, String) var dialogues
export (String) var dialog_mode
export (Array, float) var times

export (String) var next_scene_path
export (int) var new_song
export (NodePath) var Player
onready var player = get_node(Player)

func button_pressed(outro):
	if say_something:
		player.comment(dialogues, dialog_mode, times)
		if dialog_mode == "AUTO":
			yield(get_tree().create_timer(times[0]), "timeout")
	if change_song:
		LevelManager.Game.music_fade_and_change(2, new_song)
	if outro:
		LevelManager.Game.current_cutscene = 6
	LevelManager.clean_checkpoints()
	LevelManager.fade_and_call_method(LevelManager, "change_scene", next_scene_path)
