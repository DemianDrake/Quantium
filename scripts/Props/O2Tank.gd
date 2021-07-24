extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var o2_amount = 30
export var description = "An oxigen tank, very pretty, surely delicious..."
export var comment = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact(body: Node):
	if body.is_in_group('Player'):
		body.add_o2(o2_amount)
		if comment:
			body.comment(['Mmm... Delicious oxigen.'], 'AUTO', [3.0])
		queue_free()


func get_description():
	return description

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
