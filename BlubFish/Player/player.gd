extends CharacterBody2D
@onready var health_bar = $CanvasLayer/HealthBar
var bubbles = GameState.items["oxybubbles"]
@export var jump_speed = 200
@export var run_speed = 250
@export var gravity = 150
var health = GameState.player_health
var invincible = false
func hurt():
	velocity.y = -velocity.y -100
	velocity.x = -velocity.x -100
var textures = {
	"Green" : preload("res://Assets/Green.png"),
	"Yellow" : preload("res://Assets/Yellow.png"),
	"Orange" : preload("res://Assets/Orange.png"),
	"Red" : preload("res://Assets/Red.png")
}
enum {IDLE, RUN, JUMP}
var state = IDLE
func update_health(value):
	GameState.player_health = health
	$CanvasLayer/HealthBar.texture_progress = textures["Green"]
	if value < .75:
		$CanvasLayer/HealthBar.texture_progress= textures["Yellow"]
	if value < .5:
		$CanvasLayer/HealthBar.texture_progress= textures["Orange"]
	if value < .3:
		$CanvasLayer/HealthBar.texture_progress= textures["Red"]
	$CanvasLayer/HealthBar.value = value
func _process(delta):
	Update_Items("Money")
	GameState.player_posy = position.y
	GameState.player_posx = position.x
	if health <= 0:
		GameState.new_scene(0, GameState.last_scene)
	if GameState.items["oxybubbles"] != bubbles:
		update_Bubbles()

func Update_Items(type):
	if type == "Money":
		$CanvasLayer/Money.text = str("Money: ") + str(GameState.items["money"]) 
func _ready():
	update_Bubbles()
	change_state(IDLE)
	update_health(health)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$Walking.playing = false
			$AnimationPlayer.play("Swimming")
		RUN:
			if $Walking.playing != true:
				$Walking.playing = true
				$Walking.play()
			$AnimationPlayer.play("Swimming")
		JUMP:
			$AnimationPlayer.play("Swimming")
func _get_input():
	var left = Input.is_action_pressed("Left")
	var right = Input.is_action_pressed("Right")
	var Jump = Input.is_action_just_pressed("Jump")
	
	velocity.x = 0
	
	if left:
		velocity.x += -run_speed
		$Sprite2D.flip_h = true
		$CPUParticles2D.position.x = -25
	if right:
		$CPUParticles2D.position.x = 25
		velocity.x += run_speed
		$Sprite2D.flip_h = false
	if Jump and is_on_floor():
		change_state(JUMP)
		velocity.y = -jump_speed
	if JUMP and is_on_floor():
		change_state(IDLE)
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.y == 0:
		change_state(IDLE)
	if velocity.y == 0:
		$Sprite2D.rotation = 0
func _physics_process(delta):
	velocity.y += gravity * delta
	_get_input()
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("Hydro-Vent"):
			velocity.y = -200
			GameState.player_health += .125
		if collision.get_collider().is_in_group("Mines"):
			GameState.new_scene(2, 1)
		if collision.get_collider().is_in_group("Coral"):
			if health <= 1:
				health += 0.001
				update_health(health)
		if invincible == false:
			if collision.get_collider().is_in_group("MiniCrab"):
				if position.y < collision.get_collider().position.y: 
					collision.get_collider().death(true) 
					velocity.y = -100 
					#else: 
				else:
						health -= .0225
						invincible = true
						$Timer.start()
						update_health(health)
						velocity.x -= velocity.x * 2
			if collision.get_collider().is_in_group("Crab"):
				health -= .055
				update_health(health)
				invincible = true
				$Timer.start()
				velocity.x -= velocity.x * -2
				#velocity.y = -jump_speed
			if collision.get_collider().is_in_group("SwordFish"):
				health -= .0125
				update_health(health)
				invincible = true
				$Timer.start()
			if collision.get_collider().is_in_group("BossCrab"):
				$Timer.start()
				health -= .075
				invincible = true
				update_health(health)
				velocity.x -= velocity.x * -2
				#velocity.y = -jump_speed
				

func reset(_position):
	position = _position
	show()
	change_state(IDLE)
func update_Bubbles():
	bubbles = GameState.items["oxybubbles"]
	$CanvasLayer/HBoxContainer/Label.text = "Oxy-Bubbles:" + str(bubbles)
func mines():
	pass


func _on_timer_timeout():
	invincible = false
