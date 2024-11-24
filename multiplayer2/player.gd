extends CharacterBody2D

signal life_changed
signal died

@export var climb_speed = 50
@export var max_jumps = 2
@export var double_jump_factor = 1.5
@export var gravity = 0
@export var run_speed = 150
@export var jump_speed = -300

enum{IDLE, RUN, JUMP, HURT, DEAD, CLIMB}
var state = IDLE
var life = 3: set = set_life
var jump_count = 0
var is_on_ladder = false

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	print(name)
	$Camera2D.enabled = is_multiplayer_authority()

func _ready():
	if is_multiplayer_authority():
		
		change_state(IDLE)
func get_input():
	if is_multiplayer_authority():
		if state == HURT:
			return
		var up = Input.is_action_pressed("up")
		var down = Input.is_action_pressed("down")
		var right = Input.is_action_pressed("right")
		var left = Input.is_action_pressed("left")
		var jump = Input.is_action_just_pressed("jump")
		
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
				
		velocity.x = 0
		if right:
			velocity.x += run_speed
			$Sprite2D.flip_h = false
		if left:
			velocity.x -= run_speed
			$Sprite2D.flip_h = true
		if jump and state == JUMP and jump_count < max_jumps and jump_count > 0:
			$Jump_01.play()
			$AnimationPlayer.play("jump_up")
			velocity.y = jump_speed / double_jump_factor
			jump_count += 1
		if jump and is_on_floor():
			change_state(JUMP)
			velocity.y = jump_speed
			$Jump_01.play()
			jump_count += 1
		if state == IDLE and velocity.x != 0:
			change_state(RUN)
		if state == RUN and velocity.x == 0:
			change_state(IDLE)
		if state in [IDLE, RUN] and !is_on_floor():
			change_state(JUMP)
func change_state(new_state):
	if is_multiplayer_authority():
		state = new_state
		match state:
			IDLE:
				$AnimationPlayer.play("idle")
			RUN:
				$AnimationPlayer.play("run")
			HURT:
				$AnimationPlayer.play("hurt")
				velocity.y = -200
				velocity.x = -100 * sign(velocity.x)
				life -= 1
				if life >= 1 :
					await get_tree().create_timer(0.5).timeout
				change_state(IDLE)
			JUMP:
				jump_count = 0
				$AnimationPlayer.play("jump_up")
			DEAD:
				died.emit()
				hide()
			CLIMB:
				$AnimationPlayer.play("climb")

func _physics_process(delta):
	if is_multiplayer_authority():
		if state != CLIMB:
			velocity.y += gravity * delta
		get_input()
		
		move_and_slide()
		if state == HURT:
			return
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().is_in_group("danger"):
				hurt()
			if collision.get_collider().is_in_group("enemies"):
				if position.y < collision.get_collider().position.y:
					collision.get_collider().take_damage()
					velocity.y = -200
				else:
					hurt()
		if state == JUMP and is_on_floor():
			change_state(IDLE)
			jump_count = 0
			$Dust.emitting = true
		if state == JUMP and velocity.y > 0:
			$AnimationPlayer.play("jump_down")
		#if position.y > 10000:
		#	life -= 1
func reset(_position):
	if is_multiplayer_authority():
		
		position = _position
		show()
		change_state(IDLE)
		life = 3
func set_life(value):
	if is_multiplayer_authority():
		
		life = value
		life_changed.emit(life)
		if life <= 0:
			change_state(DEAD)
func hurt():
	if is_multiplayer_authority():
		
		if state != HURT:
			change_state(HURT)
			$Hurt_01.play()
			
