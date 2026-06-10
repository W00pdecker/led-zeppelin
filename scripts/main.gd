extends Node2D

@onready var canvas_layer = $CanvasLayer

func _on_start_button_pressed():
	# Убираем меню и запускаем игру
	canvas_layer.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_level_select_button_pressed():

	get_tree().change_scene_to_file(
		"res://Scenes/level_select.tscn"
	)
