extends Area

export var enabled = true
export var particles_emitting = false
export(Array, Array) var gravities

onready var particles: ParticlesMaterial

var bodies = []
var gravities_qty:int
var actual_grav = 0
var should_reload = false
var has_particles = false

const PARTICLE_VRATIO = 7

func _ready():
	var _entered_signal = connect("body_entered", self, "on_body_entered")
	var _exited_signal  = connect("body_exited", self, "on_body_exited")
	set_override()
	gravities_qty = len(gravities)
	if get_node_or_null("GravityParticles"):
		var box_size = $CollisionShape.shape.extents
		var volume = box_size.x * box_size.y * box_size.z
		has_particles = true
		$GravityParticles.emitting = particles_emitting and enabled
		$GravityParticles.amount = volume * PARTICLE_VRATIO
		particles = $GravityParticles.process_material
		particles.gravity = self.gravity_vec * self.gravity
		particles.emission_box_extents = box_size
		$GravityParticles.set_visibility_aabb(AABB(- box_size, 2 * box_size))
	
func on_body_entered(body: Node):
	bodies.append(body)
	if body.is_in_group("Player"):
		body.set_floor(self.is_in_group("floor_area"))
		body.airborne_time = 0

func on_body_exited(body: Node):
	bodies.erase(body)
	if body.is_in_group("Player"):
		body.airborne_time = 0

func _physics_process(delta):
	for body in bodies: 
		if body.is_in_group("Player") and enabled:
			if not self.gravity==0:
				body.set_up_vector(-self.gravity_vec)
			body.set_gravity(self.gravity)
	#Trucazo para recargar los bodies que ya están dentro del área - método 1
	if should_reload:
		should_reload = false
		var tmp_transform = get_global_transform()
		set_global_transform(Transform.IDENTITY)
		yield(get_tree().create_timer(2*delta), "timeout")
		set_global_transform(tmp_transform)

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
		if has_particles:
			particles.gravity = new_vector * new_scalar

#método 2: recargar cada item. No funcionó
func update_items():
	for body in bodies:
		if body.is_in_group("Items"):
			var velocity = body.linear_velocity
			body.mode = RigidBody.MODE_RIGID
			body.linear_velocity = velocity
#método 3: recargar el physicsserver. No funcionó
func update_server():
	var space = PhysicsServer.area_get_space(get_rid())
	PhysicsServer.area_set_space(get_rid(), space)

func button_pressed(mode):
	if not mode: #false = toggle
		enabled = not enabled
		if has_particles:
			$GravityParticles.emitting = enabled
		set_override()
	else: #true = cycle through gravities
		should_reload = true #método 1: tp
		actual_grav = (actual_grav + 1) % gravities_qty
		set_grav(actual_grav)
#		update_items()
#		update_server()
