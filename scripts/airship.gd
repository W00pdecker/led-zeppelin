extends CharacterBody2D

@export var MAXSPEEDY = 400.0
@export var MAXSPEEDX = 175.0
@export var LIFTFORCE = 650.0
@export var FALL_MULTIPLIER = 0.2
@export var ACCELERATION = 400.0
@export var AIR_FRICTION = 2.0
@export var GRAVITY = 400.0

var passengers_on_board: int = 0
var max_passengers: int = 4

@onready var animated_sprite = $AnimatedSprite2D
@onready var boarding_area = $BoardingArea


func _ready():

	boarding_area.body_entered.connect(_on_boarding_area_body_entered)


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

	velocity.y = clamp(velocity.y, -MAXSPEEDY, MAXSPEEDY)

	var horizontal = Input.get_axis("ui_left", "ui_right")

	if horizontal != 0 and not is_on_floor():
		velocity.x += horizontal * ACCELERATION * delta
		animated_sprite.flip_h = horizontal > 0
	else:
		velocity.x = lerp(velocity.x, 0.0, AIR_FRICTION * delta)

	velocity.x = clamp(velocity.x, -MAXSPEEDX, MAXSPEEDX)

	animated_sprite.play("fly" if horizontal != 0 else "idle")

	move_and_slide()


func pick_up_passenger() -> bool:

	if passengers_on_board >= max_passengers:
		return false

	passengers_on_board += 1
	return true


func deliver_passengers():

	if passengers_on_board > 0:
		GameManager._on_delivery(passengers_on_board)
		passengers_on_board = 0


func _on_boarding_area_body_entered(body):

	if body.is_in_group("passenger"):
		body.collect()
