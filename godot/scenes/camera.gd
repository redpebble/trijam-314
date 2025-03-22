extends Camera2D

var target: Node2D = null

func _physics_process(delta: float) -> void:
	if (!target): return
	position.x = lerp(position.x, target.position.x + 200, delta * 10)
