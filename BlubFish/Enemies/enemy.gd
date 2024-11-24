extends CharacterBody2D 
@export var type = 1
@export var speed = 50 
@export var gravity = 175
var value = 3

var facing = 1 
var _position = position
func _ready():
	_position = position
	hide()
	death(false)
func _physics_process(delta): 
	velocity.y += gravity * delta 
	velocity.x = facing * speed       
	$Sprite2D.flip_h = velocity.x > 0 
	move_and_slide() 
	for i in get_slide_collision_count(): 
		var collision = get_slide_collision(i) 
		if collision.get_collider().is_in_group("O2Bubble"):
			$Player.update_bubbles(1)
			death(true)
		if collision.get_collider().is_in_group("Player"):
			death(true)
		#if collision.get_collider().name == "Player": 
			#collision.get_collider().hurt() 
		if collision.get_normal().x != 0: 
			facing = sign(collision.get_normal().x) 
			velocity.y = -50 
			if position.y > 10000: 
				queue_free()
func death(bubble):
	if bubble:
		$Sprite2D.self_modulate = "ff0000"
		await get_tree().create_timer(.125).timeout
		$Sprite2D.self_modulate = "ffffff"
		GameState.items["money"]+= value
		GameState.items["oxybubbles"] += type
	$AnimationPlayer.pause()
	$CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
	#queue_free()
	respawn(true)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Death":
		#queue_free()
		respawn(true)
func respawn(boolean):
	var _death = randi_range(0, 6)
	if _death == 0:
		queue_free()
	hide()
	var spawn = randi_range(0, 1)
	if spawn == 0:
		position = _position
	if boolean:
		await get_tree().create_timer(randi_range(3, 7)).timeout
	$AnimationPlayer.play("Walk")
	
	$CollisionShape2D.set_deferred("disabled", false)
	show()
	set_physics_process(true)
