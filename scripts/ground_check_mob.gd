extends RayCast2D

var last_target: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:
	
	#var owner_id = target.shape_find_owner(shape_id) # The owner ID in the collider.
	#var shape = target.shape_owner_get_owner(owner_id)
	if is_colliding():
		print ("Стою на земле")
		var target = get_collider() # A CollisionObject2D.
		if target.hot:
			owner.lobotomized = false
		else:
			owner.lobotomized = true
