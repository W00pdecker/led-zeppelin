extends CharacterBody2D

const SPEED = 75.0
const LIFT = -150.0  # сила подъёма при нажатии вверх
const GRAVITY = 400.0  # сила гравитации

var passengers_on_board: int = 0
var max_passengers: int = 4

@onready var landing_zone = $LandingZone


func _ready():
	landing_zone.body_entered.connect(_on_landing_zone_entered)
	landing_zone.body_exited.connect(_on_landing_zone_exited)


func _physics_process(delta):
	# Гравитация всегда тянет вниз
	velocity.y += GRAVITY * delta

	# Вверх — подъём, вниз — быстрее падаем
	if Input.is_action_pressed("ui_up"):
		velocity.y = LIFT
	
	# Горизонтальное движение
	var horizontal = Input.get_axis("ui_left", "ui_right")
	if horizontal != 0:
		velocity.x = horizontal * SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)

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
