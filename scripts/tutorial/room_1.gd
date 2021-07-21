extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("Timer")
onready var player = get_node("Player")

var dialogues = ["Oh, I am so beautiful...", 
"This room is very metallic, many light.",
"I should look around, or better yet, I should look at myself!",
"There's a door, there might be a giant glowing yellow button to open it.",
"The door leads to the void, the rest hasn't been implemented yet xoxo."]
var current = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.comment(dialogues[current])
	current += 1
	timer.start(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if current < len(dialogues):
		timer.start(5)
		player.comment(dialogues[current])
		current += 1
