extends RigidBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact(body: Node):
	print(self.mode)
	if self.mode == RigidBody.MODE_RIGID:
		self.mode = RigidBody.MODE_STATIC
	elif self.mode == RigidBody.MODE_STATIC:
		self.mode = RigidBody.MODE_RIGID
	print(self.mode)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
