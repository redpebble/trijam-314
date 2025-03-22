extends Button

signal selected


func _ready() -> void:
	button_down.connect(_on_button_down)
	match_node_name()

func match_node_name():
	text = name

func _on_toggled(toggled_on : bool):
	if toggled_on:
		print(name, " selected")
		selected.emit()

func _on_button_down():
	print(name, " selected")
	selected.emit()
