class_name Airship
extends CharacterBody2D

@export var MAXSPEEDY = 400.0
@export var MAXSPEEDX = 175.0
@export var LIFTFORCE = 650
@export var FALL_MULTIPLIER = 0.2
@export var ACCELERATION = 400.0
@export var AIR_FRICTION = 1.0
@export var GROUND_FRICTION = 8.0
@export var BOUNCE_THRESHOLD = 10.0
@export var WALL_BOUNCE = 0.45
@export var FLOOR_BOUNCE = 0.5
@export var GRAVITY = 400.0
@export var DOCK_TIME = 0.2

var passengers_on_board: int = 0
var max_passengers: int = 4

var current_station = null
var is_docked = false
var dock_timer = 0.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var boarding_area = $BoardingArea
@onready var station_detector = $StationDetector


func _ready():

	station_detector.area_entered.connect(
		_on_station_entered
	)

	station_detector.area_exited.connect(
		_on_station_exited
	)


func _physics_process(delta):

	# gravity
	if velocity.y > 0:
		velocity.y += GRAVITY * delta * FALL_MULTIPLIER
	else:
		velocity.y += GRAVITY * delta

	# input
	if Input.is_action_pressed("ui_up"):
		velocity.y -= LIFTFORCE * delta

	if Input.is_action_pressed("ui_down"):
		velocity.y += LIFTFORCE * delta

		if not is_on_floor():
			animated_sprite.play("fall")

	velocity.y = clamp(
		velocity.y,
		-MAXSPEEDY,
		MAXSPEEDY
	)

	var horizontal = Input.get_axis(
		"ui_left",
		"ui_right"
	)

	if horizontal != 0 and not is_on_floor():

		velocity.x += horizontal * ACCELERATION * delta

		animated_sprite.flip_h = horizontal > 0

	else:
		if not (is_on_floor() or is_on_ceiling()):
			velocity.x = lerp(
				velocity.x,
				0.0,
				AIR_FRICTION * delta
			)
		else:
			velocity.x = lerp(
			velocity.x,
			0.0,
			GROUND_FRICTION * delta
		)

	velocity.x = clamp(
		velocity.x,
		-MAXSPEEDX,
		MAXSPEEDX
	)

	animated_sprite.play(
		"fly" if horizontal != 0 else "idle"
	)

	var previous_velocity = velocity

	move_and_slide()

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

	_check_docking(delta)

	if is_docked:
		_check_boarding()


func _check_docking(delta):

	if current_station == null:

		if is_docked:
			_undock()

		dock_timer = 0.0

		return

	var stable : bool = (
		is_on_floor()
		and abs(velocity.x) < 5
		#and abs(velocity.y) < 5
	)

	if stable:

		dock_timer += delta

		if dock_timer >= DOCK_TIME and not is_docked:

			is_docked = true

			current_station.ship_arrived_at_station(self)

	else:

		dock_timer = 0.0

		if is_docked:
			_undock()


func _undock():

	is_docked = false
	dock_timer = 0.0

	if current_station:
		current_station.ship_departed_from_station(self)


func _check_boarding():

	for body in boarding_area.get_overlapping_bodies():

		if body.is_in_group("passenger"):
			body.collect()


func _on_station_entered(area):

	if area is Station:
		current_station = area


func _on_station_exited(area):

	if area == current_station:

		if is_docked:
			_undock()

		current_station = null


func pick_up_passenger() -> bool:

	if passengers_on_board >= max_passengers:
		return false

	passengers_on_board += 1
	return true


func deliver_passengers():

	if passengers_on_board > 0:

		GameManager._on_delivery(
			passengers_on_board
		)

		passengers_on_board = 0
