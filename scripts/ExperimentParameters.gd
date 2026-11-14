extends Node

@export
var participant_number : int = 0

@export
var current_run_type : Player.ControlScheme

@export
var run_index = -1

@export
var current_run_time : float = 0

@export
var current_run_arrows_hit : int = 0

@export
var current_run_arrows_blocked : int = 0

@export
# The experiment aggregate scores.
var scores : Dictionary[Player.ControlScheme, int] = {}

@export
# The experiment run times, as measured in seconds.
var times : Dictionary[Player.ControlScheme, float] = {}

@export
# The experiment number of times hit.
var arrows_hit : Dictionary[Player.ControlScheme, int] = {}

@export
# The experiment number of times blocked.
var arrows_blocked : Dictionary[Player.ControlScheme, int] = {}


# Called to reset the entire experiment
func reset_experiment():
	scores = {}
	times = {}
	arrows_hit = {}
	current_run_time = 0
	current_run_arrows_hit = 0
	current_run_arrows_blocked = 0
	run_index = -1
	participant_number = 0

# Called when a run is finished.
#
# Returns true if another run should be completed.
func new_run() -> bool:
	if(run_index >= 0):
		_store_run();
	_reset_run();
	_increment_run();
	return run_index <= 2;


# Stores the current run data.
func _store_run() -> void:
	scores[current_run_type] = _calculate_current_score();
	times[current_run_type] = current_run_time;
	arrows_hit[current_run_type] = current_run_arrows_hit;
	arrows_blocked[current_run_type] = current_run_arrows_blocked;
	
	
func _calculate_current_score() -> float:
	return current_run_time * (1 + current_run_arrows_hit);


# Resets the current run information.
func _reset_run() -> void:
	current_run_time = 0
	current_run_arrows_hit = 0
	current_run_arrows_blocked = 0


# Moves the run type forward.
func _increment_run() -> void:
	run_index += 1;
	current_run_type = get_run_type(participant_number, run_index)
	

# Save the experiment data to disk.
func save_experiment() -> void:
	# Open the file
	var experiment_file = FileAccess.open(
		"user://participant_" + str(participant_number) + ".csv",
		FileAccess.WRITE
	);
	# Save the data
	experiment_file.store_line("participant,run index,run type,score,time,arrows_hit,arrows_blocked");
	for index in range(3):
		var run_controls: Player.ControlScheme = get_run_type(participant_number, index)
		experiment_file.store_line(
			str(participant_number) + "," +
			str(index) + "," +
			Player.ControlScheme.keys()[run_controls] + "," +
			str(scores[run_controls]) + "," +
			str("%.3f" % times[run_controls]) + "," +
			str(arrows_hit[run_controls]) + "," +
			str(arrows_blocked[run_controls])
		);
	
	
static func get_run_type(participant: int, run: int) -> Player.ControlScheme:
	# Calculate an index in the latin square.
	var latin_square_index = (run + participant) % 3
	# Return the control scheme for that index.
	match latin_square_index:
		0: return Player.ControlScheme.Toggled
		1: return Player.ControlScheme.Locking
		2: return Player.ControlScheme.Snapping
	# This fallback should never be needed.
	push_error("Latin square fallback used!")
	return Player.ControlScheme.Toggled
