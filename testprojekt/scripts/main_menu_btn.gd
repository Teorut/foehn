extends Button

@onready var sprites = [
	preload("res://Bilder/mainMenuBtn.png"),
	preload("res://Bilder/mainMenuBtnPressed.png")
]


func _on_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/base_scene.tscn")


func _on_mouse_entered() -> void:
	icon = sprites[1]

func _on_mouse_exited() -> void:
	icon = sprites[0]
