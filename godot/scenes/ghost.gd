class_name Ghost
extends Node2D

@export_range(0, 100, 5) var replay_lead = 30 # frames of physics ahead of player

@onready var player : Player = get_parent()
@onready var sprite := $Sprite

var current_run : Array = []
var replay_run : Array = []
var best_run : Array = []
var progress_index : int = 0

enum states {DEFAULT, DEAD, GOAL_REACHED}
var state = states.DEFAULT : set = set_state
var replay_run_result = states.DEFAULT



func _ready() -> void:
	top_level = true # decouple from parent traits
	modulate.a = 0.5
	# Connect to character signals
	player.contact_detected.connect(_on_player_contact_detected)


func _physics_process(_delta: float) -> void:
	current_run.append(player.global_transform)
	
	if replay_run.is_empty():
		hide()
		return
	else:
		show()
	
	if progress_index == replay_run.size()-1:
		set_state(replay_run_result)
	
	global_transform = replay_run[progress_index]
	progress_index = min(progress_index + 1, replay_run.size()-1)



func add_run_progess(pos : Transform2D):
	current_run.append(pos)

# saves the current run then starts another
func start_new_run():
	if current_run.is_empty() : return
	replay_run = current_run.duplicate()
	current_run.clear()
	progress_index = replay_lead
	set_state(states.DEFAULT)

func clear_all_runs():
	current_run.clear()
	replay_run.clear()


# matches color to signify the current state
func set_state(_state):
	state = _state
	match state:
		states.DEFAULT:
			sprite.modulate = Color.WHITE
		states.DEAD:
			sprite.modulate = Color.INDIAN_RED
		states.GOAL_REACHED:
			sprite.modulate = Color.LIME_GREEN

func _on_player_contact_detected(area : DetectorArea):
	match area.effect_type:
		Level.EffectType.CHECKPOINT:
			# erase progress before checkpoint
			current_run.clear()
		Level.EffectType.HAZARD:
			replay_run_result = states.DEAD
		Level.EffectType.GOAL:
			replay_run_result = states.GOAL_REACHED
	start_new_run()
