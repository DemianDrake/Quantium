extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var o2_amount = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact(body: Node):
	if body.is_in_group('Player'):
		body.add_o2(o2_amount)
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
