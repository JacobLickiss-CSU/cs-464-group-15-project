extends Node3D
class_name Player

@export
var camera : Camera3D

@export
var camera_focus : Node3D

@export
var speed : float = 10

@export
var camera_speed : float = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction : Vector3 = global_position - camera.global_position
	direction = direction.normalized()
	direction.y = 0
	if(Input.is_action_pressed('leftstick_up')):
		position += direction * delta * speed
	if(Input.is_action_pressed('leftstick_down')):
		position += -direction * delta * speed
	if(Input.is_action_pressed('leftstick_left')):
		position += -direction.cross(Vector3.UP) * delta * speed
	if(Input.is_action_pressed('leftstick_right')):
		position += direction.cross(Vector3.UP) * delta * speed
	if(Input.is_action_pressed('rightstick_up')):
		pass
	if(Input.is_action_pressed('rightstick_down')):
		pass
	if(Input.is_action_pressed('rightstick_left')):
		camera_focus.rotate(Vector3(0, 1, 0), -delta * camera_speed)
	if(Input.is_action_pressed('rightstick_right')):
		camera_focus.rotate(Vector3(0, 1, 0), delta * camera_speed)
