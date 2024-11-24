extends Node2D

@export var type = 0
@export var offset = Vector2(320, 100)
@export var duration = 10.0

func  _ready():
	var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	if type == 1:
		tween.set_trans(tween.TRANS_SPRING)
	if type == 2:
		tween.set_trans(tween.TRANS_SINE)
	tween.tween_property($TileMap, "position", offset, duration).from_current()
	tween.tween_property($TileMap, "position", Vector2.ZERO, duration)
	
