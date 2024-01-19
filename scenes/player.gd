extends CharacterBody3D

const ANGULAR_SPEED_PITCH = 50.0
const ANGULAR_SPEED_ROLL = 80.0
const ANGULAR_SPEED_YAW = 50.0
var speed = 10.0

var pitch_speed = 0.0
var roll_speed = 0.0
var yaw_speed = 0.0

func _process(delta):
	# Handle pitch, roll, and yaw input.
	pitch_speed = lerp(pitch_speed, Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"), 0.1)
	roll_speed = lerp(roll_speed, Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"), 0.1)
	yaw_speed = lerp(yaw_speed, Input.get_action_strength("game_a") - Input.get_action_strength("game_d"), 0.1)

	# Update the rotation based on pitch, roll, and yaw input.
	rotate_object_local(Vector3(1, 0, 0), pitch_speed * ANGULAR_SPEED_PITCH * delta * (PI / 180.0))
	rotate_object_local(Vector3(0, 0, 1), roll_speed * ANGULAR_SPEED_ROLL * delta * (PI / 180.0))  # Change the axis to (0, 0, 1) for roll.
	rotate_object_local(Vector3(0, 1, 0), yaw_speed * ANGULAR_SPEED_YAW * delta * (PI / 180.0))
	
	speed += Input.get_action_strength("game_w")
	speed -= Input.get_action_strength("game_s")
	
	# Move the plane forward.
	translate(Vector3(0, 0, -speed * delta))
