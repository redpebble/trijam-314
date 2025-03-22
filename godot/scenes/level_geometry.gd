extends StaticBody2D

func _ready() -> void:
	$ColorRect.position = $CollisionShape2D.position - ($CollisionShape2D.shape.size / 2)
	$ColorRect.size = $CollisionShape2D.shape.size
