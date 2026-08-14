extends Node2D

var startingPos
var playerSprite
var gameIsPaused
var levels = []

@onready var mainMenu = preload("res://Scenes/base_scene.tscn")
@onready var winScreen = preload("res://Scenes/win_screen.tscn")

func save(data):
	# Spara input-datan i en separat fil
	var save_file = FileAccess.open("user://saveFile.txt", FileAccess.WRITE)
	
	for i in data:
		save_file.store_string(str(i) + "\n")
	
	save_file.close()

func _ready() -> void:
	# Om en sparfil inte finns, skapa en som startar på nivå 1 vid (300, 500)
	var file = FileAccess.open("user://saveFile.txt", FileAccess.READ)
	if file == null:
		save([0,1000,500,2])

func startGame(doReset):
	levels = [
		preload("res://Scenes/level_0.tscn"),
		preload("res://Scenes/level_1.tscn"),
		preload("res://Scenes/level_2.tscn"),
		preload("res://Scenes/level_3.tscn"),
		preload("res://Scenes/level_4.tscn"),
		preload("res://Scenes/level_5.tscn")
	]
	
	if doReset:
		save([0,1000,500,2])
		
	var file = FileAccess.open("user://saveFile.txt", FileAccess.READ).get_as_text().split("\n")
		
	# Sätter nivån och startpositionen till deras sparade världen
	var level = int(file[0])
	get_tree().change_scene_to_packed(levels[level])
	
	startingPos = Vector2(int(file[1]), int(file[2]))
	
	playerSprite = int(file[3])

func exit(level):
	# Bestäm nästa nivå
	var newLevel = level
	
	if level >= len(levels):
		newLevel = len(levels) - 1
	
	# Spara nivån och startpositionen
	save([newLevel, startingPos.x, startingPos.y, playerSprite])
	
	# Sätt den nuvarande nivån till den nya nivån
	if level < len(levels):
		get_tree().change_scene_to_packed(levels[level])
	else:
		get_tree().change_scene_to_packed(winScreen)
