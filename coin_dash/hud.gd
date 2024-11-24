extends CanvasLayer

signal start_game

func update_score(value):
 $MarginContainer/Score.text = str(value)

func update_timer(value):
 $MarginContainer/Time.text = str(value)

func show_message(text):
 $message.text = text
 $message.show()
 $Timer.start()

func _on_timer_timeout():
 $message.hide()

func _on_start_button_pressed():
 $StartButton.hide()
 $message.hide()
 start_game.emit()

func show_game_over():
 show_message("Game Over")
 await $Timer.timeout
 $StartButton.show()
 $message.text = "Coin Dash!"
 $message.show()
