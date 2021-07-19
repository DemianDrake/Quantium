extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var inventory = get_node("Top/Hotbar/Inventory")
onready var hp_bar = get_node("Top/Bar/HP")
onready var o2_bar = get_node("Top/Bar/O2")
onready var dialogue_box = get_node("Bottom/Dialogue")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_inventory():
	return inventory


func update_hotbar(inventory):
	inventory.update_hotbar(inventory)


func update_hp(pc):
	hp_bar.update_bar(pc)


func update_o2(pc):
	o2_bar.update_bar(pc)


func show_dialogue(text: String):
	dialogue_box.setup(text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
