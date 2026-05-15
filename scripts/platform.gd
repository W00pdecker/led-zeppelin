extends Area2D

var ship_present: bool = false
var current_airship: Node2D = null


func _ready():

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _notify_passengers_ship_arrived(ship):
	for body in get_overlapping_bodies():
		if body.is_in_group("passenger"):
			body.try_start_boarding(ship)

func _notify_passengers_ship_left():
	for body in get_overlapping_bodies():
		if body.is_in_group("passenger"):
			body.stop_boarding()

func _on_body_entered(body):

	if body.is_in_group("airship"):

		ship_present = true
		current_airship = body
		_notify_passengers_ship_arrived(body)


func _on_body_exited(body):

	if body.is_in_group("airship"):

		ship_present = false
		current_airship = null
		_notify_passengers_ship_left()
