extends Node3D
class_name Player

@export
var visual_player : Node3D

@export
var camera : Camera3D

@export
var camera_focus : Node3D

@export
var camera_pivot : Node3D

@export
var speed : float = 10

@export
var camera_speed : float = 5

@export
var camera_min_height : float = -20

@export
var camera_max_height : float = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction : Vector3 = global_position - camera.global_position
	direction = direction.normalized()
	direction.y = 0
	
	# Player position movement
	if(Input.is_action_pressed('leftstick_up')):
		position += direction * delta * speed
	if(Input.is_action_pressed('leftstick_down')):
		position += -direction * delta * speed
	if(Input.is_action_pressed('leftstick_left')):
		position += -direction.cross(Vector3.UP) * delta * speed
	if(Input.is_action_pressed('leftstick_right')):
		position += direction.cross(Vector3.UP) * delta * speed
	
	# Check if the camera trigger button is held
	if(Input.is_action_pressed('camera_trigger')):
		# Camera facing movement
		if(Input.is_action_pressed('rightstick_up')):
			camera_pivot.rotate(Vector3(1, 0, 0), delta * camera_speed)
			if(camera_pivot.rotation_degrees.x > camera_max_height):
				camera_pivot.rotation_degrees = Vector3(camera_max_height, camera_pivot.rotation_degrees.y, camera_pivot.rotation_degrees.z)
		if(Input.is_action_pressed('rightstick_down')):
			camera_pivot.rotate(Vector3(1, 0, 0), -delta * camera_speed)
			if(camera_pivot.rotation_degrees.x < camera_min_height):
				camera_pivot.rotation_degrees = Vector3(camera_min_height, camera_pivot.rotation_degrees.y, camera_pivot.rotation_degrees.z)
		if(Input.is_action_pressed('rightstick_left')):
			camera_focus.rotate(Vector3(0, 1, 0), delta * camera_speed)
		if(Input.is_action_pressed('rightstick_right')):
			camera_focus.rotate(Vector3(0, 1, 0), -delta * camera_speed)
	else:
		# Player facing change
		# Getting the joystick as a vector
		#  https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html
		var stick_input = Input.get_vector("rightstick_left", "rightstick_right", "rightstick_up", "rightstick_down")
		if(stick_input.length() > 0):
			# Get a position for the player to look at
			var look_target = visual_player.global_position + Vector3(stick_input.x, 0, stick_input.y)
			# Get the player to look at that position
			visual_player.look_at(look_target)
			# Compensate for the current amount of camera focus rotation
			visual_player.rotate(Vector3(0, 1, 0), camera_focus.rotation.y)
