extends Node2D

func _ready() -> void:
	reset()
	$Camera2D.target = $Character

func reset() -> void:
	$Character.position = $Start.position
	$Camera2D.position.x = $Start.position.x

func _on_character_hit_hazard() -> void:
	reset()
