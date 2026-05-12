extends Node2D

@onready var levels = {
	1: $Level1,
	2: $Level2,
	3: $Level3,
}

func _ready():
	for level in levels.values():
		_hide_level(level)

	GameManager.passenger_collected.connect(_on_passenger_collected)


func _on_passenger_collected(total: int):
	if levels.has(total):
		_show_level(levels[total])
		print("Открылась новая платформа!")


func _hide_level(level: Node2D):
	level.visible = false

	for child in level.get_children():
		if child is TileMapLayer:
			child.collision_enabled = false


func _show_level(level: Node2D):
	level.visible = true

	for child in level.get_children():
		if child is TileMapLayer:
			child.collision_enabled = true
