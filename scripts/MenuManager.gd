extends Node

@export
var game_scene : PackedScene;

@export
var participant_selection : OptionButton;


func _on_begin_button_pressed() -> void:
	ExperimentParameters.reset_experiment();
	ExperimentParameters.participant_number = participant_selection.selected;
	get_tree().change_scene_to_packed(game_scene);


func _on_exit_button_pressed() -> void:
	get_tree().quit()
