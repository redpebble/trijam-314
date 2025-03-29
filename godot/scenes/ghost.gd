class_name Ghost
extends Node2D


var current_run : Array = []
var last_run : Array = []
var progress_index : int = 0

enum states {DEFAULT, FAIL, WIN}
var state = states.DEFAULT : set = set_state


func _ready() -> void:
	top_level = true # useful if parented by a moving node
	modulate.a = 0.5


func _physics_process(_delta: float) -> void:
	if last_run.is_empty() : return
	if progress_index >= last_run.size() : return
	global_transform = last_run[progress_index]
	progress_index += 1


func add_run_progess(pos : Transform2D):
	current_run.append(pos)

func start_new_run():
	if current_run.is_empty() : return
	last_run = current_run.duplicate()
	current_run.clear()
	progress_index = 1

func clear_all_runs():
	current_run.clear()
	last_run.clear()


func set_state(_state):
	state = _state
	match state:
		states.DEFAULT:
			modulate = Color.WHITE
		states.FAIL:
			modulate = Color.INDIAN_RED
		states.WIN:
			modulate = Color.LIME_GREEN
