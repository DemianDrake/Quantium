extends Spatial


# Declare member variables here. Examples:
# var a = 2
export var speed = 0.05
var up = Vector3.UP


# Called when the node enters the scene tree for the first time.
func _ready():
	up = (Vector3.UP + Vector3(0.001,0,0)).normalized()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):			
	rotate_object_local(up, delta * speed)
