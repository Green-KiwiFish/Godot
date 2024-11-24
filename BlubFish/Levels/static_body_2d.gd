extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#show()
	$AnimationPlayer.play("Fish")
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(_position):
	position= _position
