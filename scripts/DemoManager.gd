extends Node3D
class_name DemoManager

@export
var player : Player;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var do_another_run : bool = ExperimentParameters.new_run()
	if(!do_another_run):
		ExperimentParameters.save_experiment()
		get_tree().change_scene_to_file("res://scenes/menu_scene.tscn");
	else:
		player.controls = ExperimentParameters.current_run_type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ExperimentParameters.current_run_time += delta


func end_reached() -> void:
	get_tree().reload_current_scene()
		
