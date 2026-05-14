extends CharacterBody2D

var is_collected: bool = false
var is_boarding: bool = false
var airship: Node2D = null

@export var GRAVITY = 400.0
@export var BOARD_SPEED = 60.0
@export var BOARD_DISTANCE = 20.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var detection_area = $DetectionArea


func _ready():
	animated_sprite.play("idle")


func _physics_process(delta):
	# Гравитация
	velocity.y += GRAVITY * delta

	if is_boarding and airship != null:
		# Двигаемся к кораблю по земле
		var direction = airship.global_position - global_position
		
		if direction.x > 0:
			velocity.x = BOARD_SPEED
			animated_sprite.flip_h = false
		elif direction.x < 0:
			velocity.x = -BOARD_SPEED
			animated_sprite.flip_h = true
		
		animated_sprite.play("walk")
		
		# Проверяем расстояние до дирижабля
		if global_position.distance_to(airship.global_position) < BOARD_DISTANCE:
			collect()
	else:
		velocity.x = 0
		animated_sprite.play("idle")

	move_and_slide()


func start_boarding(target: Node2D):
	if is_collected or is_boarding:
		return
	is_boarding = true
	airship = target


func collect() -> bool:
	if is_collected:
		return false
	is_collected = true
	airship.pick_up_passenger()
	airship.passengers_in_zone.erase(detection_area)
	GameManager.on_passenger_collected()
	queue_free()
	return true
