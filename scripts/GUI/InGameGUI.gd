extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var inventory = get_node("Top/Hotbar/Inventory")
onready var hp_bar = get_node("Top/Bar/HP")
onready var o2_bar = get_node("Top/Bar/O2")
onready var dialogue_box = get_node("Bottom/Dialogue")
onready var info_box = get_node("Middle/Right/Info")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_inventory():
	return inventory


func update_hotbar(dict):
	inventory.update_hotbar(dict)


func update_hp(pc):
	hp_bar.update_bar(pc)


func update_o2(pc):
	o2_bar.update_bar(pc)


func show_dialogue(dialogues: Array, mode: String, times: Array):
	dialogue_box.setup(dialogues, mode, times)


func show_save_icon():
	var tween = $Top/Indicators/CenterContainer/TextureRect/Tween
	tween.interpolate_property($Top/Indicators/CenterContainer/TextureRect, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.interpolate_property($Top/Indicators/CenterContainer/TextureRect, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	

func show_info(text: String, group: String):
	info_box.setup(text, group)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
