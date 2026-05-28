class_name Passenger
extends CharacterBody2D

enum State {
	WAITING,
	BOARDING
}

@export var GRAVITY = 400.0
@export var BOARD_SPEED = 60.0
@export var MAX_FALL_SPEED = 500.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var station_detector = $PlatformDetector

var state = State.WAITING

var station = null
var airship = null


func _ready():

	station_detector.area_entered.connect(
		_on_station_entered
	)

	station_detector.area_exited.connect(
		_on_station_exited
	)


func _physics_process(delta):

	velocity.y += GRAVITY * delta

	velocity.y = clamp(
		velocity.y,
		-MAX_FALL_SPEED,
		MAX_FALL_SPEED
	)

	match state:

		State.WAITING:

			velocity.x = 0
			animated_sprite.play("idle")

		State.BOARDING:

			if airship == null:

				stop_boarding()

			else:

				var direction = sign(
					airship.global_position.x
					- global_position.x
				)

				velocity.x = direction * BOARD_SPEED

				if direction > 0:
					animated_sprite.flip_h = true

				elif direction < 0:
					animated_sprite.flip_h = false

				animated_sprite.play("walk")

	move_and_slide()


func start_boarding(ship):

	if state != State.WAITING:
		return

	airship = ship
	state = State.BOARDING


func stop_boarding():

	airship = null
	state = State.WAITING


func collect() -> bool:

	if airship == null:
		return false

	if airship.pick_up_passenger():

		GameManager.on_passenger_collected()

		queue_free()

		return true

	return false


func _on_station_entered(area):
	
	if not area.is_in_group("Station"):
		return
	print("ENTERED STATION")
	station = area

	station.ship_arrived.connect(
		_on_ship_arrived
	)

	station.ship_departed.connect(
		_on_ship_departed
	)

	if station.has_ship():

		start_boarding(
			station.docked_ship
		)


func _on_station_exited(area):

	if area != station:
		return

	if station.ship_arrived.is_connected(
		_on_ship_arrived
	):
		station.ship_arrived.disconnect(
			_on_ship_arrived
		)

	if station.ship_departed.is_connected(
		_on_ship_departed
	):
		station.ship_departed.disconnect(
			_on_ship_departed
		)

	stop_boarding()

	station = null


func _on_ship_arrived(ship):
	print("PASSENGER START BOARDING")
	start_boarding(ship)


func _on_ship_departed():

	stop_boarding()
