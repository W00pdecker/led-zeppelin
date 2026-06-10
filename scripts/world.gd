extends Node2D

var current_level_instance: Node = null

func _ready():		
	load_level(GameManager.current_level_path)
	var spawn = current_level_instance.get_node("Start")
	$Airship.global_position = spawn.global_position
	GameManager.passenger_collected.connect(
		_on_passenger_collected
	)
	
func load_level(level_path: String):

	if current_level_instance:
		current_level_instance.queue_free()
	var packed_scene = load(level_path)
	current_level_instance = packed_scene.instantiate()
	$CurrentLevel.add_child(current_level_instance)

func _process(delta):
	if Input.is_action_pressed("zoom"):
		$Airship/Camera2D.enabled = true
		$LevelCamera.enabled = false
	else:
		$LevelCamera.enabled = true
		$Airship/Camera2D.enabled = false

func _on_passenger_collected(total: int):
	pass


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
