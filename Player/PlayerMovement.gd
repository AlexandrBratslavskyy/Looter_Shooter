extends CharacterBody3D

## properties
# nodes
@onready var p_camera: Camera3D = $Head/Camera
@onready var gunRay: RayCast3D = $Head/Camera/RayCast3D

# resources
@export var p_stats_shared: StatsShared

# sensitivity
var p_sensitivity_x = 0.02
var p_sensitivity_y = 0.02

# gravity
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Captures mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	gunRay.add_exception(self)

func _unhandled_input(event: InputEvent) -> void:
	# debug
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseMotion:
		var MouseMovement: Vector2 = -event.relative
		rotate_y(MouseMovement.x * p_sensitivity_y) # first rotate y
		p_camera.rotate_x(MouseMovement.y * p_sensitivity_x) # then rotate x
		p_camera.rotation.x = clamp(p_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("i_jump") and is_on_floor():
		velocity.y = p_stats_shared.p_velocity_jump

	# Handle Shooting
	if Input.is_action_just_pressed("i_primary"):
		m_shoot()

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("i_move_left", "i_move_right", "i_move_up", "i_move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * p_stats_shared.p_velocity
		velocity.z = direction.z * p_stats_shared.p_velocity
	else:
		velocity.x = move_toward(velocity.x, 0, p_stats_shared.p_velocity)
		velocity.z = move_toward(velocity.z, 0, p_stats_shared.p_velocity)

	move_and_slide()

func m_shoot() -> void:
	if not gunRay.is_colliding():
		return
	var cl := gunRay.get_collider()

	if cl.has_method("take_damage"):
		cl.take_damage()
