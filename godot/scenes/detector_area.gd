class_name DetectorArea
extends Area2D

@export var effect_type := Level.EffectType.NEUTRAL

func _ready() -> void:
	collision_layer = get_collider_layer()
	connect("body_entered", _on_body_entered)

	for child in get_children():
		if not child is CollisionShape2D:
			continue
		
		var crect = ColorRect.new()
		crect.position = child.position - (child.shape.size / 2)
		crect.size = child.shape.size
		crect.color = get_rect_color()

		add_child(crect)

func _on_body_entered(body: Node2D):
	if body is Player:
		body.contact_detected.emit(self)

func get_rect_color():
	match effect_type:
		Level.EffectType.NEUTRAL:    return Color("7682d3")
		Level.EffectType.HAZARD:     return Color("bc4c3999")
		Level.EffectType.CHECKPOINT: return Color("008dea44")
		Level.EffectType.GOAL:       return Color("3e8b5d88")

func get_collider_layer():
	match effect_type:
		Level.EffectType.NEUTRAL:    return 2
		Level.EffectType.HAZARD:     return 4
		Level.EffectType.CHECKPOINT: return 8
		Level.EffectType.GOAL:       return 8
