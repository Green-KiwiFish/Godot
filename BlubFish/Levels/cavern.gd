extends Node
var music = "beat"
@export var fish_decor : PackedScene
@export var O2Bubble : PackedScene
var fish = load("res://Levels/static_body_2d.tscn")
func spawn_bubble():
	if GameState.items["oxybubbles"] > 0:
		GameState.items["oxybubbles"] -= 1
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
	$FishDecor.hide()
	spawn_fishdecor()
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
		var decor = fish_decor.instantiate()
		add_child(decor)
		decor.init($FishDecor.map_to_local(cell))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($Player.position)
	$Player.move_to_front()
	if $Player.position.y > 2000:
		#$Player.reset($SpawnPoint.position)
		GameState.new_scene(0, 2)
func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.tile_set.tile_size
	$Player/Camera2D.limit_left = (map_size.position.x - 2) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 2) * cell_size.x


func _on_music_finished():
	await get_tree().create_timer(1).timeout
	if music == "long_swell":
		music = "beat"
	elif music == "beat":
		music = "flute"
	else:
		music = "long_swell"
	if music == "long_swell":
		$Music.stream = load("res://Assets/Sound/mixkit-mysterious-long-swell-2671.wav")
	if music == "beat":
		$Music.stream = load("res://Assets/Sound/mixkit-mystwrious-bass-pulse-2298.wav")
		$Music.stream_paused = false
		$Music.playing = true
	if music == "flute":
		$Music.stream = load("res://Assets/Sound/mixkit-possitive-indian-flute-2312.wav")
	$Music.play()
func _on_area_2d_body_entered(body):
	print(body)
	if body.name == "Player":
		GameState.new_scene(1, 2)
