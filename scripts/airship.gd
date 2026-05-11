extends CharacterBody2D

@export var MAXSPEEDY = 400.0 # максимальная скорость вверх
@export var MAXSPEEDX = 75.0
@export var LIFTFORCE = 650  # сила подъёма при нажатии вверх или вниз
@export var FALL_MULTIPLIER = 0.2
const GRAVITY = 400.0  # сила гравитации

var passengers_on_board: int = 0
var max_passengers: int = 4

@onready var landing_zone = $LandingZone


func _ready():
	landing_zone.body_entered.connect(_on_landing_zone_entered)
	landing_zone.body_exited.connect(_on_landing_zone_exited)


func _physics_process(delta):
	# Гравитация всегда тянет вниз
	if velocity.y > 0:
		velocity.y += GRAVITY * delta * FALL_MULTIPLIER
	else:
		velocity.y += GRAVITY * delta

	# Вверх — подъём, вниз — быстрее падаем
	if Input.is_action_pressed("ui_up"):
		velocity.y -= LIFTFORCE * delta
	if Input.is_action_pressed("ui_down"):
		velocity.y += LIFTFORCE * delta
	# Причешем скорость
	velocity.y = clamp(velocity.y, -MAXSPEEDY, MAXSPEEDY)
	
	# Горизонтальное движение
	var horizontal = Input.get_axis("ui_left", "ui_right")
	if horizontal != 0:
		velocity.x = horizontal * MAXSPEEDX
	else:
		velocity.x = lerp(velocity.x, 0.0, 3.0 * delta)

	move_and_slide()


func pick_up_passenger() -> bool:
	if passengers_on_board < max_passengers:
		passengers_on_board += 1
		print("Пассажиров на борту: ", passengers_on_board)
		return true
	return false


func deliver_passengers():
	if passengers_on_board > 0:
		GameManager._on_delivery(passengers_on_board)
		passengers_on_board = 0
		print("Пассажиры доставлены!")


func _on_landing_zone_entered(body):
	pass


func _on_landing_zone_exited(body):
	pass
