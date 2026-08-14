extends StaticBody2D

@onready var pos = position

var doSink = false
var doDelete = false
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
	var directionRay = getRay(speedVector)
	
	# Ska stenen flyttas på något som inte är en vätska, flytta den inte
	if directionRay.is_colliding():
		if !directionRay.get_collider().isLiquid:
			return
	
	return true

func push(speedVector):
	var directionRay = getRay(speedVector)
	
	# Flyttar målpositionen
	pos += speedVector
	
	# Flyttas stenen till en vätska ska den börja sjunka
	if directionRay.is_colliding():
		if directionRay.get_collider().isLiquid:
			doSink = true
			$CollisionShape2D.disabled = true
			
func delBlock():
	# Radera blocket
	queue_free()
	
func _process(_delta: float) -> void:
	if doGlow:
		$glowBorder.visible = true
	else:
		$glowBorder.visible = false

func _physics_process(_delta: float) -> void:
	if !Global.gameIsPaused:
		doGlow = false
		
		# Flytta mjukt stenens position mot målet
		position = lerp(position, pos, 0.4)
		
		if doSink and round(position.x) == pos.x and round(position.y) == pos.y:
			# Ska stenen sjunka och den är vid sitt mål, stäng av kollisionen
			# och börja sjunka
			$sprite.z_index = 0
			$AnimationPlayer.play("Sink")
