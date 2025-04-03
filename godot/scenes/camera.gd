extends Camera2D

var target: Node2D = null
var lookahead : float = 200.0
var speed = 5

func _physics_process(delta: float) -> void:
	if (!target): return
	var scaled_lookahead = lookahead * target.get_speed_scale()
	global_position.x = lerp(global_position.x, target.global_position.x + scaled_lookahead, delta * speed)
