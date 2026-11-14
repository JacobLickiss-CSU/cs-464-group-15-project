extends CharacterBody3D
class_name Player

@export
var controls : ControlScheme = ControlScheme.Toggled

@export
var visual_player : Node3D

@export
var camera : Camera3D

@export
var camera_focus : Node3D

@export
var camera_pivot : Node3D

@export
var camera_label : Label

@export
var toggle_label : TextureRect

@export
var locking_label : TextureRect

@export
var snapping_label : TextureRect

@export
var speed : float = 10

@export
var camera_speed_horizontal : float = 2

@export
var camera_speed_vertical : float = 5

@export
var player_look_speed : float = 7

@export
var camera_min_height : float = -20

@export
var camera_max_height : float = 25

var _snap_target : Quaternion
var _has_snap_target : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	match controls:
		ControlScheme.Toggled:
			_process_toggled(delta)
			camera_label.text = "Camera mode: Toggled"
			toggle_label.visible = true
			#if(Input.is_action_just_pressed("debug_next")):
				#controls = ControlScheme.Locking
			#elif(Input.is_action_just_pressed("debug_last")):
				#controls = ControlScheme.Snapping
		ControlScheme.Locking:
			_process_locking(delta)
			camera_label.text = "Camera mode: Locking"
			locking_label.visible = true
			#if(Input.is_action_just_pressed("debug_next")):
				#controls = ControlScheme.Snapping
			#elif(Input.is_action_just_pressed("debug_last")):
				#controls = ControlScheme.Toggled
		ControlScheme.Snapping:
			_process_snapping(delta)
			camera_label.text = "Camera mode: Snapping"
			snapping_label.visible = true
			#if(Input.is_action_just_pressed("debug_next")):
				#controls = ControlScheme.Toggled
			#elif(Input.is_action_just_pressed("debug_last")):
				#controls = ControlScheme.Locking
	
	if(controls != ControlScheme.Snapping):
		_has_snap_target = false
	
	
func _process_toggled(delta: float) -> void:
	# Getting the joysticks as a vector
	#  https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
	var left_stick_input = Input.get_vector("leftstick_left", "leftstick_right", "leftstick_up", "leftstick_down")
	var right_stick_input = Input.get_vector("rightstick_left", "rightstick_right", "rightstick_up", "rightstick_down")
	
	# Player position movement
	var movement : Vector2 = left_stick_input.normalized().rotated(-camera_focus.rotation.y) * speed
	velocity = Vector3(-movement.x, 0, -movement.y);
	move_and_slide();
	#position += Vector3(-movement.x, 0, -movement.y)
	
	# Check if the camera trigger button is held
	if(Input.is_action_pressed('camera_trigger')):
		# Camera facing movement
		camera_pivot.rotate(Vector3(1, 0, 0), -right_stick_input.y * delta * camera_speed_horizontal)
		camera_focus.rotate(Vector3(0, 1, 0), -right_stick_input.x * delta * camera_speed_vertical)
		if(camera_pivot.rotation_degrees.x > camera_max_height):
			camera_pivot.rotation_degrees = Vector3(camera_max_height, camera_pivot.rotation_degrees.y, camera_pivot.rotation_degrees.z)
		if(camera_pivot.rotation_degrees.x < camera_min_height):
			camera_pivot.rotation_degrees = Vector3(camera_min_height, camera_pivot.rotation_degrees.y, camera_pivot.rotation_degrees.z)
	else:
		# Player facing change
		if(right_stick_input.length() > 0):
			# Get a position for the player to look at
			var look_target = visual_player.global_position + Vector3(right_stick_input.x, 0, right_stick_input.y)
			var old_rotation : Quaternion = visual_player.quaternion
			# Get the player to look at that position
			visual_player.look_at(look_target)
			# Compensate for the current amount of camera focus rotation
			visual_player.rotate(Vector3(0, 1, 0), camera_focus.rotation.y)
			visual_player.quaternion = old_rotation.slerp(visual_player.quaternion, delta * player_look_speed)
			

func _process_locking(delta: float) -> void:
	# Getting the joysticks as a vector
	#  https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
	var left_stick_input = Input.get_vector("leftstick_left", "leftstick_right", "leftstick_up", "leftstick_down")
	var right_stick_input = Input.get_vector("rightstick_left", "rightstick_right", "rightstick_up", "rightstick_down")
	
	# Player position movement
	var movement : Vector2 = left_stick_input.normalized().rotated(-camera_focus.rotation.y) * speed
	velocity = Vector3(-movement.x, 0, -movement.y);
	move_and_slide();
	#position += Vector3(-movement.x, 0, -movement.y)
		
	# Check if the camera trigger button is held
	if(!Input.is_action_pressed('camera_trigger')):
		if(left_stick_input.length() > 0):
			# Get a position for the player to look at
			var look_target = visual_player.global_position + Vector3(left_stick_input.x, 0, left_stick_input.y)
			var old_rotation : Quaternion = visual_player.quaternion
			# Get the player to look at that position
			visual_player.look_at(look_target)
			# Compensate for the current amount of camera focus rotation
			visual_player.rotate(Vector3(0, 1, 0), camera_focus.rotation.y)
			visual_player.quaternion = old_rotation.slerp(visual_player.quaternion, delta * player_look_speed)
	
	# Camera facing movement
	camera_pivot.rotate(Vector3(1, 0, 0), -right_stick_input.y * delta * camera_speed_horizontal)
	camera_focus.rotate(Vector3(0, 1, 0), -right_stick_input.x * delta * camera_speed_vertical)
	if(camera_pivot.rotation_degrees.x > camera_max_height):
		camera_pivot.rotation_degrees = Vector3(camera_max_height, camera_pivot.rotation_degrees.y, camera_pivot.rotation_degrees.z)
	if(camera_pivot.rotation_degrees.x < camera_min_height):
		camera_pivot.rotation_degrees = Vector3(camera_min_height, camera_pivot.rotation_degrees.y, camera_pivot.rotation_degrees.z)


func _process_snapping(delta: float) -> void:
	# Getting the joysticks as a vector
	#  https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
	var left_stick_input = Input.get_vector("leftstick_left", "leftstick_right", "leftstick_up", "leftstick_down")
	var right_stick_input = Input.get_vector("rightstick_left", "rightstick_right", "rightstick_up", "rightstick_down")
	
	# Player position movement
	var movement : Vector2 = left_stick_input.normalized().rotated(-camera_focus.rotation.y) * speed
	velocity = Vector3(-movement.x, 0, -movement.y);
	move_and_slide();
	#position += Vector3(-movement.x, 0, -movement.y)
		
	if(right_stick_input.length() > 0):
		# Get a position for the player to look at
		var look_target = visual_player.global_position + Vector3(right_stick_input.x, 0, right_stick_input.y)
		var old_rotation : Quaternion = visual_player.quaternion
		# Get the player to look at that position
		visual_player.look_at(look_target)
		# Compensate for the current amount of camera focus rotation
		visual_player.rotate(Vector3(0, 1, 0), camera_focus.rotation.y)
		visual_player.quaternion = old_rotation.slerp(visual_player.quaternion, delta * player_look_speed)
		
	if(Input.is_action_just_pressed('camera_trigger')):
		var old_rotation : Quaternion = camera_focus.quaternion
		camera_focus.rotation = visual_player.rotation
		_snap_target = camera_focus.quaternion
		camera_focus.quaternion = old_rotation
		_has_snap_target = true;
	if(_has_snap_target):
		camera_focus.quaternion = camera_focus.quaternion.slerp(_snap_target, delta * camera_speed_horizontal)


enum ControlScheme {
	Toggled,
	Locking,
	Snapping
}
