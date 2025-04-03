class_name Tracker
extends Node2D

@onready var linked_node : Node2D = get_parent()

var transform_record : = []
var velocity_record := []
var action_record := []
var direction_record := []


func _ready() -> void:
	TrackerManager.trackers.append(self)
	tree_exited.connect(TrackerManager.trackers.erase.bind(self))
	if linked_node is Player:
		linked_node.contact_detected.connect(_on_player_contact_detected)


func _physics_process(_delta: float) -> void:
	record()


func record():
	transform_record.append(linked_node.global_transform)
	if linked_node is Player:
		velocity_record.append(linked_node.velocity)
		action_record.append(linked_node.controller_state)
		direction_record.append(linked_node.direction)
	
	if transform_record.size() > TrackerManager.MAX_REWIND:
		transform_record.pop_front()
		if linked_node is Player:
			velocity_record.pop_front()
			action_record.pop_front()
			direction_record.pop_front()


func rewind(idx : int, preview : bool) -> void:
	var rewind_limit = transform_record.size() - 1
	if idx > rewind_limit:
		idx = rewind_limit
	var rewind_idx = rewind_limit - idx
	# sync attributes to indexed state 
	linked_node.transform = transform_record[rewind_idx]
	if linked_node is Player:
		linked_node.velocity = velocity_record[rewind_idx]
		linked_node.controller_state = action_record[rewind_idx]
		linked_node.direction = direction_record[rewind_idx]
	if preview == false:
		# delete records after the rewind index
		transform_record.resize(rewind_idx + 1)
		velocity_record.resize(rewind_idx + 1)
		action_record.resize(rewind_idx + 1)
		direction_record.resize(rewind_idx + 1)


func reset() -> void:
	transform_record.clear()
	velocity_record.clear()
	action_record.clear()


func _on_player_contact_detected(area : DetectorArea):
	if area.effect_type == Level.EffectType.HAZARD \
	or area.effect_type == Level.EffectType.GOAL:
		reset()
