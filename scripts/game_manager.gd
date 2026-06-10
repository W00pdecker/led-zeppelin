extends Node

signal score_updated(new_score: int)
signal level_complete
signal passenger_collected(total: int)  # новый сигнал

var score: int = 0
var passengers_delivered: int = 0
var passengers_collected: int = 0  # новая переменная
var level_target: int = 10
var current_level_path := ""


func on_passenger_collected():
	passengers_collected += 1
	emit_signal("passenger_collected", passengers_collected)
	print("Всего собрано: ", passengers_collected)
	if passengers_collected > 3:
		print("YOU WIN!")


func _on_delivery(count: int):
	passengers_delivered += count
	score += count * 100
	emit_signal("score_updated", score)
	if passengers_delivered >= level_target:
		emit_signal("level_complete")


func reset():
	score = 0
	passengers_delivered = 0
	passengers_collected = 0
