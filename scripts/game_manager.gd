extends Node

signal score_updated(new_score: int)
signal level_complete

var score: int = 0
var passengers_delivered: int = 0
var level_target: int = 10


func _on_delivery(count: int):
	passengers_delivered += count
	score += count * 100
	emit_signal("score_updated", score)

	if passengers_delivered >= level_target:
		emit_signal("level_complete")


func reset():
	score = 0
	passengers_delivered = 0
