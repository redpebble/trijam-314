class_name Player
extends CharacterBody2D

enum Action { NONE, JUMP, CROUCH }

signal contact_detected(area: DetectorArea)
signal died

const MAX_SPEED = 300.0
const JUMP_VELOCITY = -400.0

var controller_state := Action.NONE
var direction = 1 # 1 for right, -1 for left
var just_died = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if controller_state == Action.JUMP and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if is_on_wall() && !just_died:
		direction *= -1
	just_died = false
	
	velocity.x = MAX_SPEED * direction

	move_and_slide()

func _process(_delta: float) -> void:
	if controller_state == Action.CROUCH:
		scale.y = .5
	else:
		scale.y = 1
	
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if not collider is LevelGeometry:
			continue

func _on_pause_menu_action_selected(action:String) -> void:
	controller_state = Action.get(action)

func get_speed_scale() -> float:
	return velocity.x / MAX_SPEED
