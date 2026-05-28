class_name Station
extends Area2D

signal ship_arrived(ship)
signal ship_departed()

var docked_ship = null


func has_ship() -> bool:
	return docked_ship != null


func ship_arrived_at_station(ship):

	if docked_ship == ship:
		return

	docked_ship = ship

	print("SHIP ARRIVED")

	ship_arrived.emit(ship)


func ship_departed_from_station(ship):

	if docked_ship != ship:
		return

	docked_ship = null

	print("SHIP DEPARTED")

	ship_departed.emit()
