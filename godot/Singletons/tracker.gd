class_name Tracker
extends Node2D

@onready var linked_node : Node2D = get_parent()

var universal_properties := ["global_transform"]
var player_properties := ["velocity", "controller_state", "direction"]
var records : Dictionary = {}



func _ready() -> void:
	TrackerManager.trackers.append(self)
	tree_exited.connect(TrackerManager.trackers.erase.bind(self))
	if linked_node is Player:
		linked_node.contact_detected.connect(_on_player_contact_detected)
	initialize_records()


func _physics_process(_delta: float) -> void:
	record()


func record():
	for property in records.keys():
		records[property].append(linked_node.get(property))
	if get_record_size() > TrackerManager.MAX_REWIND:
		for property in records.keys():
			records[property].pop_front()


func rewind(idx : int, preview : bool) -> void:
	var rewind_limit = get_record_size() - 1
	if idx > rewind_limit:
		idx = rewind_limit
	var rewind_idx = rewind_limit - idx
	# sync attributes to indexed state 
	for property in records.keys():
		linked_node.set(property, records[property][rewind_idx])
	
	if not preview:
		# delete records after the rewind index
		for property in records.keys():
			records[property].resize(rewind_idx)


func initialize_records() -> void:
	for p in universal_properties:
		records[p] = []
	if linked_node is Player:
		for p in player_properties:
			records[p] = []


func get_record_size():
	var nonspecific_property = records.keys()[0]
	return records[nonspecific_property].size()


func reset_records() -> void:
	for property in records.keys():
		records[property].clear()


func _on_player_contact_detected(area : DetectorArea):
	if area.effect_type == Level.EffectType.HAZARD \
	or area.effect_type == Level.EffectType.GOAL:
		reset_records()
