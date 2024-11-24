extends Node
@export var O2Bubble : PackedScene
var fish = load("res://Levels/static_body_2d.tscn")
func spawn_bubble():
	if GameState.bubbles > 0:
		GameState.bubbles -= 1
		var bubble = O2Bubble.instantiate()
		add_child(bubble)
		bubble.position = $Player.position
		if $Player/Sprite2D.flip_h == true:
			bubble.position.x -= 20
		if $Player/Sprite2D.flip_h == false:
			bubble.position.x += 20
		bubble.velocity += $Player.velocity
	# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.reset($SpawnPoint.position)
	#$FishDecor.hide()
	set_camera_limits()
	#spawn_fishdecor()
func _physics_process(delta):
	get_input()
func get_input():
	var Bubble = Input.is_action_just_pressed("Bubble")
	if Bubble:
		spawn_bubble()
func spawn_fishdecor():
	var fishdecor = $FishDecor.get_used_cells(0)
	for cell in fishdecor:
		var data = $FishDecor.get_cell_tile_data(0, cell)
		var decor = fish.instantiate()
		add_child(decor)
		decor.init($FishDecor.map_to_local(cell)/10)
		#print(decor.position)
		#print("decor")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($Player.position)
	$Player.move_to_front()
	if $Player.position.y > 2000:
		#$Player.reset($SpawnPoint.position)
		GameState.new_scene(0, 1)
func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.tile_set.tile_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x


func _on_music_finished():
	$Music.play()
func _mines_body_entered(body):
	GameState.new_scene(2, 1)
