extends Node

@export var Pass = 9899
var idle = false
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("Rotate Space")
	await  get_tree().create_timer(10).timeout
	$AnimationPlayer.play("TITTLE")
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("Rotate Space")
	await get_tree().create_timer(300).timeout
	idle = true
	$AnimationPlayer.pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event):
	if event.is_action_pressed("ui_select"):
		GameState.new_scene(1, 0)
