extends Node3D

@export
var player_raycast : RayCast3D

@export
var arrow : PackedScene

@export
var fire_cooldown : float = 1

@export
var fire_height : float = 1

var _remaining_cooldown : float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_remaining_cooldown = fire_cooldown
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(Vector3(_get_player().global_position.x, global_position.y, _get_player().global_position.z))
	_remaining_cooldown -= delta;
	if(_remaining_cooldown <= 0):
		_try_fire();
		
		
func _try_fire() -> void:
	if(_player_in_sight()):
		_fire()
	
	
func _fire() -> void:
	_remaining_cooldown = fire_cooldown;
	var new_arrow : Arrow = arrow.instantiate() as Arrow;
	get_parent().add_child(new_arrow)
	new_arrow.global_position = global_position + Vector3(0, fire_height, 0);
	new_arrow.set_target(_get_player())
	#player_raycast.add_exception(new_arrow.get_collider())


func _get_player() -> Player:
	if(get_parent() is not DemoManager):
		push_error("Archer cannot find player");
		return null
	return (get_parent() as DemoManager).player;
	
	
func _player_in_sight() -> bool:
	player_raycast.target_position = to_local(_get_player().global_position)
	#player_raycast.to_local(_get_player().global_position - player_raycast.global_position) - player_raycast.position;
	player_raycast.force_raycast_update();
	if(player_raycast.is_colliding()):
		var collider = player_raycast.get_collider();
		if((collider as Node3D).is_in_group("player")):
			return true;
		if((collider as Node3D).is_in_group("shield")):
			return true;
	return false;
