extends CanvasLayer

signal action_selected(action)

@onready var action_list = $MarginContainer/VBoxContainer/ActionList
@onready var resume_button = $MarginContainer/VBoxContainer/Resume
@onready var timeline : HSlider = get_node("%Timeline")

var is_paused = false : set = set_paused
var rewind_value : float = 0.0


func _ready() -> void:
	set_paused(false)
	resume_button.pressed.connect(set_paused.bind(false))
	timeline.value_changed.connect(_on_timeline_value_changed)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		set_paused(not is_paused)
	if is_paused:
		if Input.is_action_just_pressed("scroll_up"):
			timeline.value += timeline.step
		elif Input.is_action_just_pressed("scroll_down"):
			timeline.value -= timeline.step


func set_paused(state : bool):
	is_paused = state
	get_tree().paused = is_paused
	visible = is_paused
	if not is_paused:
		#print(rewind_value)
		var action : String = action_list.get_selected_action().to_upper()
		TrackerManager.rewind_by(rewind_value, false)
		action_selected.emit(action)
	else:
		timeline.step = 1.0 / TrackerManager.get_record_size()
		timeline.value = 1
 

func _on_timeline_value_changed(value) -> void:
	rewind_value = 1.0 - value
	TrackerManager.rewind_by(rewind_value, true)
