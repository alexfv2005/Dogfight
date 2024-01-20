# input.gd
extends MultiplayerSynchronizer

#Syncronize properties
@export var rotation_speeds := Vector3()
@export var speed := 10.0

func _ready():
	#Disable for non local player instances
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(delta):
	#Get the input
	rotation_speeds.x = lerp(rotation_speeds.x, Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"), 0.1)
	rotation_speeds.y = lerp(rotation_speeds.y, Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0.1)
	rotation_speeds.z = lerp(rotation_speeds.z, Input.get_action_strength("game_a") - Input.get_action_strength("game_d"), 0.1)

	speed += Input.get_action_strength("game_w")
	speed -= Input.get_action_strength("game_s")
