extends HBoxContainer

@onready var button_nodes : Array[Node] = self.get_children()

func _ready() -> void:
	connect_signals()
	button_nodes[0].button_pressed = true

func _on_button_selected(b):
	var other_buttons = button_nodes.duplicate()
	other_buttons.erase(b)
	for i in other_buttons:
		i.button_pressed = false

func get_selected_action():
	var action := "None"
	for i in button_nodes:
		if i.button_pressed:
			action = i.name
			break
	return action

func connect_signals():
	for i in button_nodes:
		i.selected.connect(_on_button_selected.bind(i))
