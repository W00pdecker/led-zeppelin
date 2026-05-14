extends CharacterBody2D

#Константы физики
@export var MAXSPEEDY = 400.0 # максимальная скорость вверх
@export var MAXSPEEDX = 175.0
@export var LIFTFORCE = 650  # сила подъёма при нажатии вверх или вниз
@export var FALL_MULTIPLIER = 0.2
@export var ACCELERATION = 400.0
@export var AIR_FRICTION = 2.0
@export var BOUNCE_THRESHOLD = 10.0
@export var WALL_BOUNCE = 0.45
@export var FLOOR_BOUNCE = 0.5
@export var GRAVITY = 400.0  # сила гравитации

#Константы пассажиров или, ну я не знаю, всякие константы
var passengers_on_board: int = 0
var max_passengers: int = 4
var passengers_in_zone: Array = []

@onready var landing_zone = $LandingZone
@onready var animated_sprite = $AnimatedSprite2D


func _ready():
	landing_zone.area_entered.connect(_on_landing_zone_area_entered)
	landing_zone.area_exited.connect(_on_landing_zone_area_exited)


func _physics_process(delta):
	# Гравитация всегда тянет вниз
	if velocity.y > 0:
		velocity.y += GRAVITY * delta * FALL_MULTIPLIER
	else:
		velocity.y += GRAVITY * delta

	# Вверх — подъём, вниз — быстрее падаем
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		animated_sprite.play("fly")
	else:
		animated_sprite.play("idle")		

	if Input.is_action_pressed("ui_up"):
		velocity.y -= LIFTFORCE * delta
		
	if Input.is_action_pressed("ui_down"):
		velocity.y += LIFTFORCE * delta
		
	velocity.y = clamp(velocity.y, -MAXSPEEDY, MAXSPEEDY)
	
	# Горизонтальное движение
	var horizontal = Input.get_axis("ui_left", "ui_right")
	if horizontal != 0:
		velocity.x += horizontal * ACCELERATION * delta
		animated_sprite.flip_h = horizontal > 0
	else:
		velocity.x = lerp(velocity.x, 0.0, AIR_FRICTION * delta)
	velocity.x = clamp(velocity.x, -MAXSPEEDX, MAXSPEEDX)
	
	var previous_velocity = velocity
	move_and_slide()
	#физика столкновений
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		if abs(normal.x) > 0.7:
			if abs(previous_velocity.x) > BOUNCE_THRESHOLD:
				velocity.x = -previous_velocity.x * WALL_BOUNCE
			else:
				velocity.x = 0
		if abs(normal.y) > 0.7:
			if abs(previous_velocity.y) > BOUNCE_THRESHOLD:
				velocity.y = -previous_velocity.y * FLOOR_BOUNCE
			else:
				velocity.y = 0
	
	# Проверяем подбор пассажиров каждый кадр
	print("on_floor: ", is_on_floor(), " | in_zone: ", passengers_in_zone.size())
	if is_on_floor() and passengers_in_zone.size() > 0:
		print("ready for boarding")
	for passenger in passengers_in_zone.duplicate():
			if is_instance_valid(passenger) and not passenger.is_boarding:
				passenger.start_boarding(self)

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


func _on_landing_zone_area_entered(area):
	if area.is_in_group("passenger"):
		passengers_in_zone.append(area.get_parent())

func _on_landing_zone_area_exited(area):
	if area.is_in_group("passenger") and not area.get_parent().is_boarding:
		passengers_in_zone.erase(area.get_parent())
	if area.is_in_group("passenger") and area.get_parent().is_boarding:
		passengers_in_zone.erase(area.get_parent())
		area.get_parent().is_boarding = false
