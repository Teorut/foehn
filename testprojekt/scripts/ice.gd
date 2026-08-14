extends StaticBody2D

@onready var ground = preload("res://Scenes/Prefabs/ground.tscn")
@onready var groundFolder: Node = $"../../Ground"
@onready var pos = position

var collidingLiquid = null
var doGlow = false

@export var isPushable: bool
@export var isLiquid: bool

func getRay(speedVector):
	# Ger en viss ray beroende på vart speedvectorn pekar
	if speedVector.x < 0:
		return $RayLeft
	elif speedVector.y < 0:
		return $RayUp
	elif speedVector.x > 0:
		return $RayRight
	else:
		return $RayDown

func checkPush(speedVector):
	# Kör om isblocket inte kolliderar med en vätska
	if !collidingLiquid:
		var directionRay = getRay(speedVector)
		
		# Ska isblocket flyttas på något som inte är en vätska, flytta den inte
		if directionRay.is_colliding():
			if !directionRay.get_collider().isLiquid:
				return
		
		return true
	
	return

func push(speedVector):
	var directionRay = getRay(speedVector)
	
	# Flyttar målpositionen
	pos += speedVector
	
	# Flyttas isblocket till en vätska ska den börja sjunka
	if directionRay.is_colliding():
		if directionRay.get_collider().isLiquid:
			collidingLiquid = directionRay.get_collider()

func spawnIce():
	var ground_instance = ground.instantiate()
	
	ground_instance.position = pos
	
	groundFolder.add_child(ground_instance)
	
	queue_free()
	collidingLiquid.queue_free()
	
func _process(_delta: float) -> void:
	if doGlow:
		$glowBorder.visible = true
	else:
		$glowBorder.visible = false

func _physics_process(_delta: float) -> void:
	if !Global.gameIsPaused:
		position = lerp(position, pos, 0.4)
		
		doGlow = false
		
		if collidingLiquid and round(position.x) == pos.x and round(position.y) == pos.y:
			$side.z_index = 0
			$CollisionShape2D.disabled = true
			$AnimationPlayer.play("Sink")
