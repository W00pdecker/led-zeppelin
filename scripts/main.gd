extends Node2D

@onready var canvas_layer = $CanvasLayer


func _ready():
	# Пауза игры пока показывается меню
	pass


func _on_button_pressed():
	# Убираем меню и запускаем игру
	print("Кнопка нажата!")  # проверяем что функция вызывается
	canvas_layer.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
