extends Area2D

@export var exit_scene: int

@export var isPushable: bool
@export var isLiquid: bool

@onready var doExit = false

func _process(_delta: float) -> void:
	# Byt nivå om den ska bytas
	if doExit:
		Global.exit(exit_scene)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		doExit = true
		
		# Updatera värdena i sparfilen om spelaren ska flyttas till en ny nivå
		if exit_scene < len(Global.levels):
			# Sätt startpositionen till utgångspositionen
			Global.startingPos = position
			
			# Flytta startpositionen till motsatt sida av skärmen från utgången
			if position.x >= 1800:
				Global.startingPos.x = 100
			elif position.x >= 0:
				Global.startingPos.x = 1700
			elif position.y >= 1000:
				Global.startingPos.y = 100
			elif position.y >= 0:
				Global.startingPos.y = 900
