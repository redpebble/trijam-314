class_name Ghost
extends Node2D

@onready var player : Player = get_parent()
@onready var sprite := $Sprite

var current_run : Array = []
var last_run : Array = []
var best_run : Array = []
var progress_index : int = 0

enum states {DEFAULT, DEAD, GOAL_REACHED}
var state = states.DEFAULT : set = set_state
var last_run_result = states.DEFAULT : set = set_last_run_result



func _ready() -> void:
	top_level = true # useful if parented by a moving node
	modulate.a = 0.5
	# Connect to character signals
	player.hit_hazard.connect(set_last_run_result.bind(states.DEAD))
	player.hit_hazard.connect(start_new_run)
	player.hit_goal.connect(set_last_run_result.bind(states.GOAL_REACHED))
	player.hit_goal.connect(start_new_run)


func _physics_process(_delta: float) -> void:
	print(global_position)
	current_run.append(player.global_transform)
	
	if last_run.is_empty():
		hide()
		return
	else:
		show()
	
	if progress_index >= last_run.size():
		set_state(last_run_result)
		return
	
	global_transform = last_run[progress_index]
	progress_index += 1



func add_run_progess(pos : Transform2D):
	current_run.append(pos)

# saves the current run then starts another
func start_new_run():
	if current_run.is_empty() : return
	last_run = current_run.duplicate()
	current_run.clear()
	progress_index = 20
	set_state(states.DEFAULT)

func clear_all_runs():
	current_run.clear()
	last_run.clear()


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

func set_last_run_result(_last_run_result):
	last_run_result = _last_run_result
