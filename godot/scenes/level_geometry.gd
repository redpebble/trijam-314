class_name LevelGeometry
extends StaticBody2D

enum Type { NEUTRAL, HAZARD, GOAL }
@export var collision_type := Type.NEUTRAL

func _ready() -> void:
	for child in get_children():
		if not child is CollisionShape2D:
			continue
		
		var crect = ColorRect.new()
		crect.position = child.position - (child.shape.size / 2)
		crect.size = child.shape.size

		match collision_type:
			Type.NEUTRAL: crect.color = Color("7682d3")
			Type.HAZARD:  crect.color = Color("bc4c39")
			Type.GOAL:    crect.color = Color("3e8b5d")

		add_child(crect)
