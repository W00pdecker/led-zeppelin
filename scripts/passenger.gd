extends Area2D

var is_collected: bool = false
@onready var animated_sprite = $AnimatedSprite2D


func _ready():
	body_entered.connect(_on_body_entered)
	animated_sprite.play("idle")


func _on_body_entered(body):
	if body.is_in_group("airship") and not is_collected:
		is_collected = true
		if body.pick_up_passenger():
			print("Пассажир подобран!")
			GameManager.on_passenger_collected()
			queue_free()  # удаляем пассажира со сцены
