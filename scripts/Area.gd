extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bodies = []
var player_gravity_default = 9.8

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	
func on_body_entered(body: Node):
	bodies.append(body)
	
func on_body_exited(body: Node):
	if "up" in body and "gravity" in body:
		body.up = Vector3.UP
		body.gravity = player_gravity_default
	bodies.erase(body)

func _physics_process(_delta):
	for body in bodies: 
		if "up" in body and "gravity" in body:
			#print_debug("player in area")
			body.up = -self.gravity_vec
			body.gravity = self.gravity
