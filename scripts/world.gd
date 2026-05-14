extends Node2D

@onready var levels = {
	0: $Level0,
	1: $Level1,
	2: $Level2,
	3: $Level3,
}

func _ready():
	for level in levels.values():
		_hide_level(level)
	_show_level(levels[0])
		

	GameManager.passenger_collected.connect(_on_passenger_collected)

func _process(delta):
	if Input.is_action_pressed("zoom"):
		$Airship/Camera2D.enabled = true
		$LevelCamera.enabled = false
		print("Нажал, радуйся")
	else:
		$LevelCamera.enabled = true
		$Airship/Camera2D.enabled = false

func _on_passenger_collected(total: int):
	if levels.has(total):
		_show_level(levels[total])
		_hide_level(levels[total-1])
		print("Открылась новая платформа!")


func _hide_level(level: Node2D):
	level.visible = false

	for child in level.get_children():
		if child is TileMapLayer:
			child.collision_enabled = false
		if child is Area2D:
			child.monitoring = false
			child.monitorable = false


func _show_level(level: Node2D):
	level.visible = true

	for child in level.get_children():
		if child is TileMapLayer:
			child.collision_enabled = true
		if child is Area2D:
			child.monitoring = true
			child.monitorable = true
