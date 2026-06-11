extends Node2D

var current_level_instance: Node = null

func _ready():	
	$LevelSelect.visible = false		
	load_level(GameManager.current_level_path)
	$LevelSelect.level_selected.connect(
		_on_level_selected
	)
	$LevelSelect.back_pressed.connect(
		_on_back_pressed
	)
	GameManager.passenger_collected.connect(
		_on_passenger_collected
	)
	
func _process(delta):
	if Input.is_action_pressed("zoom"):
		$Airship/Camera2D.enabled = true
		$LevelCamera.enabled = false
	else:
		$LevelCamera.enabled = true
		$Airship/Camera2D.enabled = false

func load_level(level_path: String):
	
	if current_level_instance:
		current_level_instance.queue_free()
	var packed_scene = load(level_path)
	current_level_instance = packed_scene.instantiate()
	$CurrentLevel.add_child(current_level_instance)
	var spawn = current_level_instance.get_node("Start")
	$Airship.global_position = spawn.global_position

func _on_level_selected(level_path):

	get_tree().paused = false
	$LevelSelect.visible = false
	GameManager.current_level_path = level_path
	load_level(level_path)

func _on_back_pressed():

	$LevelSelect.visible = false
	get_tree().paused = false

func _unhandled_input(event):

	if event.is_action_pressed("pause_menu"):
		toggle_pause_menu()

func toggle_pause_menu():

	$LevelSelect.visible = !$LevelSelect.visible
	get_tree().paused = $LevelSelect.visible

func _on_passenger_collected(total: int):
	pass
