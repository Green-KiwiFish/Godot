extends Node
var music = "long_swell"
var chunk_number = 6
@export var fish_decor : PackedScene
@export var O2Bubble : PackedScene
var chunks = {
	"1" : load("res://Levels/chunks/chunk1.tscn"),
	"2" : load("res://Levels/chunks/chunk2.tscn"),
	"3" : load("res://Levels/chunks/chunk3.tscn"),
	"4" : load("res://Levels/chunks/chunk4.tscn"),
	"5" : load("res://Levels/chunks/chunk_5.tscn"),
	"6" : load("res://Levels/chunks/chunk.tscn")
}
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
	$Player.show()
	#$FishDecor.hide()
	$Music.play()
	if GameState.last_scene == 0:
		$Player.reset($SpawnPoint.position)
	if GameState.last_scene == 2:
		$Player.reset($Area2D.position)
	#$FishDecor.hide()
	set_camera_limits()
	spawn_chuncks()
	#spawn_fishdecor()
	#spawn_fishdecor()
func _physics_process(delta):
	get_input()
	
	if $Player.is_in_group("Mines"):
		GameState.new_scene(2, 1)
func get_input():
	var Bubble = Input.is_action_just_pressed("Bubble")
	if Bubble:
		spawn_bubble()
func spawn_chuncks():
	
	var chun1 = chunks[str(randi_range(1, chunk_number))].instantiate()
	var chun2 = chunks[str(randi_range(1, chunk_number))].instantiate()
	var chun3 = chunks[str(randi_range(1, chunk_number))].instantiate()
	var chun4 = chunks[str(randi_range(1, chunk_number))].instantiate()
	var chun5 =  chunks[str(randi_range(1, chunk_number))].instantiate()
	var chun6 =  chunks[str(randi_range(1, chunk_number))].instantiate()
	add_child(chun2)
	add_child(chun1)
	add_child(chun3)
	add_child(chun4)
	add_child(chun5)
	add_child(chun6)
	chun6.position = Vector2(256, 228)
	chun5.position = Vector2(256, 100)
	chun4.position = Vector2(0, 228)
	chun3.position = Vector2(128, 228)
	chun2.position = Vector2(128, 100)
	chun1.position = Vector2(0,100)
func spawn_fishdecor():
	var fishdecor = $FishDecor.get_used_cells(0)
	for cell in fishdecor:
		var data = $FishDecor.get_cell_tile_data(0, cell)
		var decor = fish_decor.instantiate()
		add_child(decor)
		decor.init($FishDecor.map_to_local(cell))
		#print(decor.position)
		#print("decor")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($Player.position)
	$Player.move_to_front()
	if $Player.position.y > 1000:
		#$Player.reset($SpawnPoint.position)
		GameState.new_scene(0, 1)
func set_camera_limits():
	var map_size = 64
	var cell_size = Vector2(16, 16)
	$Player/Camera2D.limit_left = 0
	$Player/Camera2D.limit_right = 640


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
		GameState.new_scene(2, 1)
