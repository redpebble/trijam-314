class_name Level
extends Node2D

@export var next_level_res: Resource

func _ready() -> void:
	$Character.connect("hit_hazard", reset)
	$Character.connect("hit_goal", load_next_level)

	reset()
	$Camera2D.target = $Character

func reset() -> void:
	$Character.position = $Start.position
	$Camera2D.position.x = $Start.position.x

var load_lock = false
func load_next_level() -> void:
	if load_lock: return # prevent this from being triggered multiple times concurrently
	load_lock = true

	if next_level_res == null:
		reset() # this should probably be something else, eventually
		load_lock = false
		return

	get_tree().change_scene_to_packed(next_level_res)
