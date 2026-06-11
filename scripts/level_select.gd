extends Node2D

@onready var levels_container = $Control/MarginContainer/VBoxContainer

signal level_selected(level_path)
signal back_pressed

func _ready():
	load_levels()

func load_levels():
	var level_files: Array[String] = []
	
	
	var dir = DirAccess.open("res://Levels")
	if dir == null:
		push_error("Cannot open Levels folder")
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(".tscn"):
				level_files.append(file_name)
		file_name = dir.get_next()

	dir.list_dir_end()
	level_files.sort()

	for level_file in level_files:
		create_level_button(level_file)

func create_level_button(level_file: String):

	var button = Button.new()
	button.text = level_file.get_basename()
	button.pressed.connect(
	func():
		level_selected.emit(
			"res://Levels/" + level_file
		)
		print("pressed button " + level_file)
)
	levels_container.add_child(button)
	
func _on_back_button_pressed():

	back_pressed.emit()
	print("pressed button back")
