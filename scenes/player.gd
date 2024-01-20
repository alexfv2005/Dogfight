# player.gd
extends CharacterBody3D

const ANGULAR_SPEED_PITCH = 50.0
const ANGULAR_SPEED_ROLL = 80.0
const ANGULAR_SPEED_YAW = 50.0

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$Input.set_multiplayer_authority(id)

# Player synchronized input.
@onready var input = $Input

func _ready():
	# Set the camera as current if we are this player.
	if player == multiplayer.get_unique_id():
		$Camera3D.current = true
	# Only process on server.
	# EDIT: Let the client simulate player movement too to compesate network input latency.
	# set_physics_process(multiplayer.is_server())


func _physics_process(delta):
	rotate_object_local(Vector3(1, 0, 0), input.rotation_speeds.x * ANGULAR_SPEED_PITCH * delta * (PI / 180.0))
	rotate_object_local(Vector3(0, 0, 1), input.rotation_speeds.y * ANGULAR_SPEED_ROLL * delta * (PI / 180.0))  # Change the axis to (0, 0, 1) for roll.
	rotate_object_local(Vector3(0, 1, 0), input.rotation_speeds.z * ANGULAR_SPEED_YAW * delta * (PI / 180.0))
	
	# Move the plane forward.
	translate(Vector3(0, 0, input.speed * delta))
