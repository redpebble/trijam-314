extends Control

signal action_selected(action)

@onready var action_list = $MarginContainer/VBoxContainer/ActionList
@onready var resume_button = $MarginContainer/VBoxContainer/Resume

var is_paused = false : set = set_paused


func _ready() -> void:
	set_paused(true)
	resume_button.pressed.connect(set_paused.bind(false))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		set_paused(not is_paused)


func set_paused(state : bool):
	is_paused = state
	get_tree().paused = is_paused
	visible = is_paused
	print("pause")
	
	if not is_paused:
		var action : String = action_list.get_selected_action().to_lower()
		action_selected.emit(action)
