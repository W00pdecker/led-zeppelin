extends Node2D

@onready var canvas_layer = $CanvasLayer
@onready var level_select = $LevelSelect

func _ready():	
	level_select.visible = false		
	level_select.level_selected.connect(
		_on_level_selected
	)
	level_select.back_pressed.connect(
		_on_back_pressed
	)

func _on_start_button_pressed():
	# Убираем меню и запускаем игру
	canvas_layer.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	GameManager.current_level_path = (
		"res://Levels/level_0.tscn" 
	)
	
func _on_level_select_button_pressed():

	level_select.visible = true
	canvas_layer.visible = false

func _on_level_selected(level_path):
	print("level " + level_path + " selected")
	GameManager.current_level_path = level_path
	get_tree().change_scene_to_file(
		"res://Scenes/world.tscn"
	)

func _on_back_pressed():

	level_select.visible = false
	get_tree().paused = false
