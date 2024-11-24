extends CharacterBody2D

signal life_changed
signal died

@export var life = 3: set = set_life
var jump_count = 0
var is_on_ladder = false

@export var climb_speed = 50
@export var max_jumps = 3
@export var double_jumpfactor = 1.25
@export var gravity = 750
@export var run_speed = 200
@export var jump_speed = -200

enum {IDLE, RUN, JUMP, HURT, DEAD, CLIMB}
var state = IDLE

func _process(delta):
	if life != GameState.life1:
		life = GameState.life1
func set_life(value):
	life = value
	GameState.life1 = life
	life_changed.emit(life)
	if life <= 0:
		change_state(DEAD)

func hurt():
	if state != HURT:
		$Hurt.play()
		change_state(HURT)
		

func _ready():
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$AnimationPlayer.play("idle")
		RUN:
			$AnimationPlayer.play("run")
		HURT:
			$AnimationPlayer.play("hurt")
			velocity.y = jump_speed * 1.2
			velocity.x = -100 * sign(velocity.x)
			life -= 1
			await get_tree().create_timer(0.35).timeout
			if life <= 0:
				died.emit()
			change_state(IDLE)
		JUMP:
			$AnimationPlayer.play("jump_up")
			jump_count = 1
		DEAD:
			hide()
		CLIMB:
			$AnimationPlayer.play("climb")

func get_input():
	if state == HURT:
		return
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var up = Input.is_action_pressed("climb")
	var down = Input.is_action_pressed("crouch")
	velocity.x = 0
	# movement occurs in all states
	if up and state != CLIMB and is_on_ladder:
		change_state(CLIMB)
	if state == CLIMB:
		if up:
			velocity.y = -climb_speed
			$AnimationPlayer.play("climb")
		elif down:
			velocity.y = climb_speed
			$AnimationPlayer.play("climb")
		else:
			velocity.y = 0
			$AnimationPlayer.stop()
	if state == CLIMB and not is_on_ladder:
		change_state(IDLE)
	if right:
		velocity.x = run_speed
		$Sprite2D.flip_h = false
	if left:
		velocity.x = -run_speed
		$Sprite2D.flip_h = true
	if jump and state == JUMP and jump_count < max_jumps and jump_count > 0:
		$Jump.play()
		$AnimationPlayer.play("jump_up")
		velocity.y = jump_speed / double_jumpfactor
		jump_count += 1
	# only allows jumping when on the ground
	if jump and is_on_floor():
		change_state(IDLE)
		jump_count = 0
		$Jump.play()
		velocity.y = jump_speed
	# IDLE tansitions to RUN when moving
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	# RUN transititions to IDLE when standing still
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	# transition to JUMP while in the air
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
		
		

func _physics_process(delta):
	if state != CLIMB:
		velocity.y += gravity * delta
	get_input()
	move_and_slide()
	if state == HURT:
		return
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("Danger"):
			hurt()
		if collision.get_collider().is_in_group("enemies"):
			if position.y < collision.get_collider().position.y:
				collision.get_collider().take_damage()
				velocity.y = -200
			else:
				hurt()
	


	#move_and_slide()
	if state == HURT:
		return
	if state == JUMP and is_on_floor():
		change_state(IDLE)
		$Dust.emitting = true
	if state == JUMP and velocity.y > 0:
		$AnimationPlayer.play("jump_down")

func reset(_position):
	position = _position
	show()
	change_state(IDLE)
