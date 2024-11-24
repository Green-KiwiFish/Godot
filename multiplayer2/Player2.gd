extends CharacterBody2D
var lol
@onready var cam = $Camera2D
const SPEED = 300.0
var eDelta = 0
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	print(name)
	lol = bool(is_multiplayer_authority())
	$Camera2D.enabled = lol#cam.enabled = true

func _physics_process (delta):
	eDelta = delta
	if is_multiplayer_authority ():
		if Input.is_action_pressed("ui_left"):
			position.x -= delta * SPEED
		if Input.is_action_pressed ("ui_right"):
			position.x += delta * SPEED
		if Input.is_action_pressed("ui_up"):
			position.y = delta * SPEED
		if Input.is_action_pressed ("ui_down"):
			position.y += delta * SPEED
		if Input.is_action_just_pressed ("exit"):
			$"../". exit_game (name)
@rpc("unreliable", "any_peer", "call_remote") func updatepos(id,pos):
	if !is_multiplayer_authority():
		if name == id:
			position = lerp(position,pos,eDelta * 18)


func _on_timer_timeout():
	if is_multiplayer_authority():
		rpc("updatepos", name, position)
