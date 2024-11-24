extends CharacterBody2D
var gravity = 100
func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("Player"):
			velocity.x = collision.get_collider().velocity.x
