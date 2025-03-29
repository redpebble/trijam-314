class_name Level
extends Node2D

@export var next_level_res: Resource

@onready var ghost := $Ghost
@onready var character := $Character
@onready var camera := $Camera2D

func _ready() -> void:
	character.connect("hit_hazard", reset)
	character.connect("hit_goal", load_next_level)
	character.connect("hit_goal", ghost.clear_all_runs)

	reset()
	camera.target = character

func reset() -> void:
	character.direction = 1
	character.position = $Start.position
	character.position.x = $Start.position.x
	#camera.global_position = character.global_position
	if ghost : ghost.start_new_run()

func _physics_process(_delta: float) -> void:
	if ghost : ghost.add_run_progess(character.global_transform)


var load_lock = false
func load_next_level() -> void:
	if load_lock: return # prevent this from being triggered multiple times concurrently
	load_lock = true

	if next_level_res == null:
		reset() # this should probably be something else, eventually
		load_lock = false
		return

	get_tree().change_scene_to_packed(next_level_res)
