extends Node2D

func _ready() -> void:
	reset()

func reset() -> void:
	$Character.position = $Start.position

func _on_character_hit_hazard() -> void:
	reset()
