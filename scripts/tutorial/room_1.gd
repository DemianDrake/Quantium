extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node("Player")

var dialogues = ["Oh, I am so beautiful...", 
"This room is very metallic, many light.",
"I should look around, or better yet, I should look at myself!",
"There's a door, there might be a giant glowing yellow button to open it.",
"The door leads to the void, the rest hasn't been implemented yet xoxo."]

# Called when the node enters the scene tree for the first time.
func _ready():
	player.comment(dialogues, "MANUAL")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
