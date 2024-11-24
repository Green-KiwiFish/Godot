extends Node

var debug = true
@export var player_posx = 0
@export var player_posy = 0
#items |-
var items = {
	"oxybubbles" : 0,
	"money" : 0
}
#@export var bubbles = 0
#@export var Money = 0
#items -|
@export var scene = 0
@export var path = ""
@export var last_scene = 0
@export var player_health = 1
var tittle_scene = "res://Levels/tittle.tscn"
var game_scene = "res://main.tscn"
var cavern_scene = "res://Levels/cavern.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	if debug:
		items["oxybubbles"] = 100
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if debug:
		print(items)
	#pass

func new_scene(_scene_number, _last_scene):
	last_scene = _last_scene
	scene = _scene_number
	if scene == 0:
		player_health = 1
		items["oxybubbles"] = 0
		items["money"] = 0
		get_tree().change_scene_to_file(tittle_scene)
	if scene == 1:
		path = "res://Levels/home.tscn"
	if scene == 2:
		path = cavern_scene
	if scene != 0:
		get_tree().change_scene_to_file(game_scene)

 
