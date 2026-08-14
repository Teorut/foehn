extends Control

func _on_start_game_button_down() -> void:
	Global.startGame(false)
	Global.gameIsPaused = false

func _on_new_game_button_down() -> void:
	Global.startGame(true)
	Global.gameIsPaused = false
