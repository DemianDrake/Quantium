extends Area

var bodies = []
#onready var default_grav = self.gravity

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	
func on_body_entered(body: Node):
	bodies.append(body)
	if body.is_in_group("Player"):
		body.set_floor(self.is_in_group("floor_area"))
		body.airborne_time = 0


func on_body_exited(body: Node):
	#if body.is_in_group("Player"):
		#body.set_gravity(PLAYER_GRAVITY_DEFAULT)
		#body.set_up_vector(Vector3.UP)
	bodies.erase(body)

func _physics_process(_delta):
	for body in bodies: 
		if body.is_in_group("Player"):
			if not self.gravity==0:
				body.set_up_vector(-self.gravity_vec)
			body.set_gravity(self.gravity)
