#player collision layer = 2 to avoid spawnning in the same location and fly.

extends CharacterBody3D

@onready var camera = $Camera3D
@onready var collition_player = $body

const SPEED = 6
const JUMP_VELOCITY = 4.5
var gravity = 15

# setting the authority for players
func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	#check the authority
	if not is_multiplayer_authority():
		return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# set the camera tothe correct player
	camera.current = true

func _unhandled_input(event):
	#check the authority
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)	
		
func _physics_process(delta):
	#check the authority
	if not is_multiplayer_authority():
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

