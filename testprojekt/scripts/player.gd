extends CharacterBody2D

@onready var pos
@onready var canMove
@onready var sprite = $sprite

var speed = 100
var canPull = false

# Laddar och sparar alla spelarens sprites
var sprites = [
	preload("res://Bilder/textures/playerLeft.png"),
	preload("res://Bilder/textures/playerUp.png"),
	preload("res://Bilder/textures/playerRight.png"),
	preload("res://Bilder/textures/playerDown.png")
]

func checkMovement(ray, speedVector, pullRay):
	var doMove = true
	
	# Om spelaren har ett objekt på en viss sida av sig...
	if ray.get_collider() != null:
		var collidingObj = ray.get_collider()
		
		# Om objektet kan puttas och inget är ivägen för objektet...
		if collidingObj.isPushable and collidingObj.checkPush(speedVector):
			# Flytta på objektet
			collidingObj.push(speedVector)
		else:
			# Annars ska spelaren inte flyttas
			doMove = false
	
	# Om spelaren ska flyttas...
	if doMove:
		canMove = false
		
		# Flytta målpositionen
		pos += speedVector
		
		# Om spelaren kan dra objekt och det finns ett objekt bakom den...
		if canPull and pullRay.is_colliding():
			# Kan objektet dras ska dess målposition flyttas
			if pullRay.get_collider().isPushable:
				pullRay.get_collider().pos = position

func _ready() -> void:
	# Sätter spelarens position och målposition till startpositionenen
	position = Global.startingPos
	pos = position
	
	sprite.texture = sprites[Global.playerSprite]
	
	canMove = false
	
	# Startar timern som stoppar spelaren från att röra sig i en halv sekund
	$Timer.start()
	
func changeSprite(index):
	sprite.texture = sprites[index]
	Global.playerSprite = index

func _physics_process(_delta: float) -> void:
	if !Global.gameIsPaused:
		if Input.is_action_just_pressed("r"):
			# Om r-knappen har tryckts ned ska nivån startas om
			get_tree().reload_current_scene()
			
		# Avgör om spelaren ska dra blocks beroende på om space eller ctrl är nedtryckt
		canPull = Input.is_action_pressed("pull")
		
		if canPull:
			for ray in [$RayLeft, $RayUp, $RayRight, $RayDown]:
				if ray.get_collider() != null:
					if ray.get_collider().isPushable:
						ray.get_collider().doGlow = true 
		
		# Om spelaren kan röra sig, kolla om någon riktning är nedtryckt
		# Vrid spelaren åt det hållet och flytta den om den kan flyttas dit
		if canMove:
			if Input.is_action_pressed("left"):
				checkMovement($RayLeft, Vector2(-speed,0), $RayRight) 
				changeSprite(0)
			elif Input.is_action_pressed("up"):
				checkMovement($RayUp, Vector2(0,-speed), $RayDown)
				changeSprite(1)
			elif Input.is_action_pressed("right"):
				checkMovement($RayRight, Vector2(speed,0), $RayLeft)
				changeSprite(2)
			elif Input.is_action_pressed("down"):
				checkMovement($RayDown, Vector2(0,speed), $RayUp)
				changeSprite(3)
		
		# Mjukt flyttar spelarens position till spelpositionen
		position = lerp(position, pos, 0.4)
		
		# Om spelarens position är nära målet, hoppa dit och låt spelaren röra sig
		if round(position.x) == pos.x and round(position.y) == pos.y and $Timer.is_stopped():
			position = pos
			canMove = true
