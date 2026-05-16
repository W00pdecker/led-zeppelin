extends CharacterBody2D

@export var GRAVITY = 400.0
@export var BOARD_SPEED = 60.0
@export var MAX_FALL_SPEED = 500.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var platform_detector = $PlatformDetector

var is_collected: bool = false
var is_boarding: bool = false
var airship: Node2D = null
var current_platform: Area2D = null

func _ready():

	animated_sprite.play("idle")
	platform_detector.area_entered.connect(_on_platform_entered)
	platform_detector.area_exited.connect(_on_platform_exited)


func _physics_process(delta):

	velocity.y += GRAVITY * delta
	velocity.y = clamp(velocity.y, -MAX_FALL_SPEED, MAX_FALL_SPEED)

	# движение к кораблю
	if is_boarding and airship != null:

		var direction = airship.global_position - global_position

		if direction.x > 0:
			velocity.x = BOARD_SPEED
			animated_sprite.flip_h = true

		elif direction.x < 0:
			velocity.x = -BOARD_SPEED
			animated_sprite.flip_h = false

		else:
			velocity.x = 0

		animated_sprite.play("walk")
		
	else:
		velocity.x = 0
		animated_sprite.play("idle")
	move_and_slide()

func start_boarding(target: Node2D):

	if is_collected or is_boarding:
		return

	if target == null:
		return

	is_boarding = true
	airship = target
	
func stop_boarding():
	is_boarding = false
	airship = null

func collect() -> bool:

	if is_collected:
		return false

	if airship == null:
		return false

	if airship.pick_up_passenger():
		is_collected = true
		GameManager.on_passenger_collected()
		queue_free()
		return true

	return false


func _on_platform_entered(area):

	current_platform = area


func _on_platform_exited(area):

	if current_platform == area:
		current_platform = null
