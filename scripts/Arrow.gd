extends Node3D
class_name Arrow

@export
var speed : float = 20

@export
var aim_offset : Vector3 = Vector3(0, 1, 0)

var _direction : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += _direction * speed * delta


func set_target(player: Player) -> void:
	var target = player.global_position + aim_offset;
	look_at(target)
	_direction = (target - global_position).normalized()


func _on_collision_area_body_entered(body: Node3D) -> void:
	if(body.is_in_group("player")):
		ExperimentParameters.current_run_arrows_hit += 1
	if(body.is_in_group("shield")):
		ExperimentParameters.current_run_arrows_blocked += 1
	queue_free()
