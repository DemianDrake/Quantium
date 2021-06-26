extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var size;
onready var text;

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_size() # Replace with function body.
	text = get_node("ColorRect/MarginContainer/ColorRect/Label").get_text()
	text = text.split(' ')[0]

func update_bar(pc):
	var new_size = Vector2(size[0] * pc, size[1])
	var new_text = text + ' ' + str(int(pc*100)) + '%'
	get_node("ColorRect/MarginContainer/ColorRect")._set_size(new_size)
	get_node("ColorRect/MarginContainer/ColorRect/Label").set_text(new_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
