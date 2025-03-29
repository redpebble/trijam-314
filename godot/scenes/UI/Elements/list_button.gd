extends Button

signal selected


func _ready() -> void:
	button_down.connect(_on_button_down)
	match_node_name()

func match_node_name():
	text = name

func _on_button_down():
	silent_press()
	selected.emit()

# press the button without triggering signals
func silent_press():
	disabled = true
	button_pressed = true
	disabled = false
