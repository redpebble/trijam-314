class_name Level
extends Node2D

enum EffectType { NEUTRAL, HAZARD, CHECKPOINT, GOAL }

@export var next_level_res: Resource
@onready var player := $Player
@onready var camera := $Camera2D
@onready var spawn: Vector2 = $Start.position

func _ready() -> void:
	player.connect("contact_detected", _on_player_contact_detected)

	reset()
	camera.target = player

func reset():
	spawn = $Start.position
	kill_player()

func kill_player() -> void:
	player.direction = 1
	player.position = spawn
	camera.position.x = spawn.x

func set_checkpoint(cp_area) -> void:
	print(cp_area.name)
	var point = cp_area.get_node("Point")
	if point:
		spawn = point.position
		return
	
	for child in cp_area.get_children():
		if child is CollisionShape2D:
			spawn = child.position
			spawn.y += child.shape.size.y / 2
			return

var load_lock = false
func load_next_level() -> void:
	if load_lock: return # prevent this from being triggered multiple times concurrently
	load_lock = true

	if next_level_res == null:
		kill_player() # this should probably be something else, eventually
		load_lock = false
		return

	get_tree().change_scene_to_packed(next_level_res)

func _on_player_contact_detected(area: DetectorArea):
	print(area.name)
	match area.effect_type:
		EffectType.HAZARD:     kill_player()
		EffectType.CHECKPOINT: set_checkpoint(area)
		EffectType.GOAL:       load_next_level()
