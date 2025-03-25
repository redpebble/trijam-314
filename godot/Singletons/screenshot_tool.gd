extends Node


var relative_directory = "user://screenshots/"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("screenshot"):
		save_screenshot()

func save_screenshot():
	if not OS.is_debug_build() : return
	
	DirAccess.make_dir_absolute(relative_directory)
	
	await RenderingServer.frame_post_draw
	var date = Time.get_date_string_from_system().replace(".","_") 
	var time :String = Time.get_time_string_from_system().replace(":","")
	var project = ProjectSettings.get("application/config/name")
	var filename = project + " " + date + " " + time + ".jpg"
	
	var image = get_viewport().get_texture().get_image()
	var error = image.save_png(relative_directory + filename)
	
	var dir = OS.get_data_dir() + "/Godot/app_userdata/" + project + "/screenshots"
	
	if error == OK:
		print("Screenshot saved to ", dir)
		OS.shell_show_in_file_manager(dir)
	else:
		printerr("Did not save screenshot to ", dir)
