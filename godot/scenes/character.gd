extends CharacterBody2D

signal hit_hazard

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum CharacterAction { NONE, JUMP, CROUCH }
var controller_state := CharacterAction.NONE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if controller_state == CharacterAction.JUMP and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.x = SPEED

	move_and_slide()

func _process(_delta: float) -> void:
	# TESTING ONLY
	if Input.is_action_pressed("jump"):
		controller_state = CharacterAction.JUMP
	elif Input.is_action_pressed("crouch"):
		controller_state = CharacterAction.CROUCH
	else:
		controller_state = CharacterAction.NONE

	if controller_state == CharacterAction.CROUCH:
		$CollisionShape2D.shape.height = 20
		if Input.is_action_just_pressed("crouch"):
			$CollisionShape2D.position.y += 10
	else:
		$CollisionShape2D.shape.height = 40
		if Input.is_action_just_released("crouch"):
			$CollisionShape2D.position.y -= 10
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("hazards"):
			hit_hazard.emit()
