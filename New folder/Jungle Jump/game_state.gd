extends Node

@export var score1 = 0
@export var life1 = 3
var num_levels = 6
var current_level = 0
var game_scene = "res://main.tscn" 
var title_screen = "res://ui/tittle.tscn" 

func restart():
	score1 = 0
	life1 = 3
	current_level = 0 
	get_tree().change_scene_to_file(title_screen) 

func next_level(): 
	current_level += 1 
	if current_level <= num_levels:
		life1 +=1.5
			 
		
		get_tree().change_scene_to_file(game_scene)
	else:
		restart()
