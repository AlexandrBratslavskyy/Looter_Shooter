extends CharacterBody3D

@onready var cam: Camera3D = $Head/Camera
@onready var gunRay: RayCast3D = $Head/Camera/RayCast3D

@export var health: Health

var mouseSensibility = 120
var mouse_relative_x = 0
var mouse_relative_y = 0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Captures mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	gunRay.add_exception(self)
#	print(health.cur_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	# Release mouse to escape
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle Shooting
	if Input.is_action_just_pressed("shoot"):
		shoot()

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensibility
		cam.rotation.x -= event.relative.y / mouseSensibility
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)

func shoot() -> void:
	if not gunRay.is_colliding():
		return
	var cl := gunRay.get_collider()

	if cl.has_method("take_damage"):
		cl.take_damage()
