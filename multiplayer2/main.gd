extends Node2D
var id_available = 1
var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
@onready var cam = $Camera2D


func _on_host_pressed():
	peer.create_server(12399)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	cam.enabled = false


func _on_join_pressed():
	peer.create_client("172.16.50.7", 12399)
	multiplayer.multiplayer_peer = peer
	cam.enabled = false
	#await get_tree().create_timer(2)
	#add_player()

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	
func exit_game (id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc ("_del_player", id)
	
@rpc("any_peer", "call_remote") func _del_player(id):
	get_node(str(id)).queue_free()
