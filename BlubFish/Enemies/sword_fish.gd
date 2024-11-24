extends CharacterBody2D
@export var speed_factor = .125
@export var range = 40
var speed_limit = 50
var _pos = 0
var sleep = false
var health = 3
var bubbleval = 5
var value = 20
func _ready():
	_pos = position
	health = 0
	death(false)
func death(items):
	health-=1
	$Sprite2D.self_modulate = "ffffff"
	await get_tree().create_timer(.0625).timeout
	$Sprite2D.self_modulate = "ff0000"
	await get_tree().create_timer(.0625).timeout
	$Sprite2D.self_modulate = "ffffff"
	if health <= 0:
		$Damage.set_deferred("disabled", true)
		set_physics_process(false)
		if items:
			GameState.items["oxybubbles"] += bubbleval
			GameState.items["money"] += value
		var w = 5
		for x in w:
			$Sprite2D.self_modulate = "ff0000"
			show()
			await get_tree().create_timer(.25).timeout
			hide()
			await get_tree().create_timer(.25).timeout
		respawn()


func _physics_process(delta):
	$Sprite2D/ZZZs.emitting = false
	
	#velocity = Vector2(0,0)
	rotation = 0
	move_and_slide()
	
	if abs((GameState.player_posx - position.x) + (GameState.player_posy - position.y)) < range:
		velocity = Vector2((GameState.player_posx - position.x)/speed_factor, (GameState.player_posy - position.y)/speed_factor)
		#velocity.x = (GameState.player_posx - position.x) * 2.75
		#velocity.y = (GameState.player_posy - position.y) * 2.5
	for i in get_slide_collision_count(): 
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("O2Bubble"):
			collision.get_collider().death()
			death(true)
		if collision.get_collider().is_in_group("Player"):
			velocity.y -= (velocity.y + 50) * 2
			velocity.x -= (velocity.x + 50) * 2
	if sleep:
		velocity = Vector2(0,0)
		$Sprite2D/ZZZs.emitting = true
	if velocity.x > speed_limit:
		velocity.x = speed_limit
	if velocity.x < -speed_limit:
		velocity.x = -speed_limit
	if velocity.y > speed_limit:
		velocity.y = speed_limit
	if velocity.y < -speed_limit:
		velocity.y = -speed_limit
	if velocity.y < 0:
		$Sprite2D.flip_h = true
		$Sprite2D/ZZZs.position.x = 10
	else :
		$Sprite2D.flip_h = false
		$Sprite2D/ZZZs.position.x = -10



func _on_sleep_timeout():
	sleep = true
	$Sleep.paused = true
	await get_tree().create_timer(1).timeout
	sleep = false
	$Sleep.start()
func respawn():
	await  get_tree().create_timer(2, 10).timeout
	show()
	$Damage.set_deferred("disabled", false)
	set_physics_process(true)
	health += 3
	$Sprite2D.self_modulate = "ffffff"
	position = _pos
	sleep = true
	var xxd = randi_range(0, 2)
	if xxd == 0:
		queue_free()
