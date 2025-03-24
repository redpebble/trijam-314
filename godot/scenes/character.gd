class_name Character
extends CharacterBody2D

enum Action { NONE, JUMP, CROUCH }

signal hit_hazard

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var controller_state := Action.NONE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if controller_state == Action.JUMP and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.x = SPEED

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

		match collider.collision_type:
			LevelGeometry.Type.HAZARD: hit_hazard.emit()
			LevelGeometry.Type.GOAL:   hit_hazard.emit()

func _on_pause_menu_action_selected(action:String) -> void:
	controller_state = Action.get(action)
