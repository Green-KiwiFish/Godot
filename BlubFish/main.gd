extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var scenne = str(GameState.path)
	
	var path = scenne
	var level = load(path).instantiate()
	add_child(level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
