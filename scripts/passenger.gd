extends Area2D

var is_collected: bool = false
var is_boarding: bool = false  # начал ли движение к кораблю
var airship: Node2D = null     # ссылка на дирижабль
@export var BOARD_SPEED = 3.0       # скорость движения к кораблю
@export var BOARD_DISTANCE = 2.0    # расстояние при котором считается подобранным

@onready var animated_sprite = $AnimatedSprite2D

	


func _ready():
	animated_sprite.play("idle")


func _process(delta):
	if is_boarding and airship != null:
		# Плавно двигаемся к дирижаблю
		global_position = global_position.lerp(airship.global_position, BOARD_SPEED * delta)
		animated_sprite.play("walk")
		
		# Проверяем расстояние до дирижабля
		if global_position.distance_to(airship.global_position) < BOARD_DISTANCE:
			collect()


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
	airship.passengers_in_zone.erase(self)
	GameManager.on_passenger_collected()
	queue_free()
	return true
