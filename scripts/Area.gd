extends Area

var bodies = []
export var enabled = true
export(Array, Array) var gravities
var gravities_qty:int
var actual_grav = 0
#onready var default_grav = self.gravity

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	set_override()
	gravities_qty = len(gravities)
	
func on_body_entered(body: Node):
	bodies.append(body)
	if body.is_in_group("Player"):
		body.set_floor(self.is_in_group("floor_area"))
		body.airborne_time = 0

func on_body_exited(body: Node):
	bodies.erase(body)

func _physics_process(_delta):
	for body in bodies: 
		if body.is_in_group("Player") and enabled:
			if not self.gravity==0:
				body.set_up_vector(-self.gravity_vec)
			body.set_gravity(self.gravity)

func set_override():
	if enabled:
		set_space_override_mode(Area.SPACE_OVERRIDE_REPLACE)
	else:
		set_space_override_mode(Area.SPACE_OVERRIDE_DISABLED)

func set_grav(index):
	if index < gravities_qty:
		var new_vector = gravities[index][0]
		var new_scalar = gravities[index][1]
		set_gravity_vector(new_vector)
		set_gravity(new_scalar)

func button_pressed(mode):
	if not mode: #false = toggle
		enabled = not enabled
		set_override()
	else: #true = cycle through gravities
		actual_grav = (actual_grav + 1) % gravities_qty
		set_grav(actual_grav)
