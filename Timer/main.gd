extends Node

var _minutes = 5
var minutes = _minutes
var _seconds = 5
var seconds = _seconds
var time_playing = false
var on_minutes = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "M: " + str(_minutes) + " S: " + str(_seconds)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_playing == true and seconds <= -1 and minutes <= 0:
		$Timer.stop()
		$Label.text = "M: 0 S: 0"
		if $Beep.playing == false:
			$Beep.play()
	else :
		$Beep.stop()
	if on_minutes:
		$Hover.position.x = $Minutes.position.x + 35
		$Hover.position.y = $Minutes.position.y + 20
	if on_minutes == false:
		$Hover.position.x = $Seconds.position.x + 35
		$Hover.position.y = $Seconds.position.y + 20

func _on_start_pressed():
	if time_playing == false and seconds == _seconds:
		seconds = _seconds
		time_playing = true
		#$Label.show()
		$Timer.start()
		$Label.text = "M: " + str(minutes) + " S: " + str(seconds)

func _on_timer_timeout():
	if time_playing:
		seconds -= 1
		if seconds == -1:
			if minutes != 0:
				minutes -= 1
				seconds = 59
	$Label.text = "M: " + str(minutes) + " S: " + str(seconds)


func _on_pause_toggled(toggled_on):
	if toggled_on:
		time_playing = false
	else:
		time_playing = true

func _on_reset_pressed():
	seconds = _seconds
	minutes = _minutes
	$Label.text = "M: " + str(minutes) + " S: " + str(seconds)
	$Timer.wait_time = 1
	time_playing = false

func _on_minus_pressed():
	if on_minutes:
		_minutes -= 1
		minutes -= 1
	else:
		_seconds -= 1 # Replace with function body.
		seconds -= 1
	$Label.text = "M: " + str(_minutes) + " S: " + str(_seconds)
	$Timer.stop()

func _on_plus_pressed():
	if on_minutes:
		_minutes += 1
		minutes += 1
	else:
		_seconds += 1 # Replace with function body.
		seconds += 1
	$Label.text = "M: " + str(_minutes) + " S: " + str(_seconds)
	$Timer.stop()


func _on_minutes_pressed():
	on_minutes = true

func _on_seconds_pressed():
	on_minutes = false
