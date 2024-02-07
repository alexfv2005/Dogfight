extends RigidBody3D

var mouse_sensitivity := 0.0006
var twist_input := 0.0
var pitch_input := 0.0

var inverted_basis: Basis

@onready var twist_camera := $TwistCamera
@onready var pitch_camera := $TwistCamera/PitchCamera
@onready var ship := $TwistPivot/PitchPivot/CharacterBody3D/ship
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var camera:=$TwistCamera/PitchCamera/Camera3D
@onready var prisma:=$TwistPivot/PitchPivot/CharacterBody3D/prisma


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#inverted_basis = Basis(-pitch_pivot.basis.x,- pitch_pivot.basis.y, pitch_pivot.basis.z)
	var input := Vector3.ZERO
	#print(twist_pivot.rotation)
	ship.transform.origin = twist_pivot.transform.origin
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	#print(abs(PI/2))																													55    
	
	apply_central_force(twist_pivot.basis*pitch_pivot.basis * input * 1200.0 * delta)
	
	

	#if pitch_pivot.rotation<0:
		#apply_central_force(-pitch_pivot.basis*twist_pivot.basis * input * 1200.0 * delta)
	
	var aligned_force = twist_pivot.basis * input
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	
	

	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	
	pitch_camera.rotation.x+=(pitch_pivot.rotation.x-pitch_camera.rotation.x)*0.07
	twist_camera.rotation.y=twist_pivot.rotation.y
	#twist_camera.rotation.y+=(twist_pivot.rotation.y-pitch_camera.rotation.y)*0.00001
	#ship.rotate_x(pitch_input)
	
	pitch_camera.rotation.x = clamp(pitch_camera.rotation.x,
		pitch_pivot.rotation.x+deg_to_rad(-10), 
		pitch_pivot.rotation.x+deg_to_rad(10)
	)
	twist_input = 0.0
	pitch_input = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if abs(rad_to_deg(pitch_pivot.rotation.y))<120:
				twist_input = - event.relative.x * mouse_sensitivity
				pitch_input = - event.relative.y * mouse_sensitivity
			#if abs(rad_to_deg(pitch_pivot.rotation.y))>120:
