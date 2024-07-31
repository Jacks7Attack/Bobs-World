extends StaticBody2D

@onready var test = preload("res://cannon_ball.tscn")
@onready var sprite = $Sprite2D
@onready var cannonFire = $CannonFire
@onready var spawnArea = $SpawnArea

@export var canJumpOn = true
@export var cooldown = 3.0
@export var survivalTime = 5.0
@export var decibelLevel = -4.0
@export var startingTime = 0.0
@export var spriteSpinSpeed = -360.0
@export var speed = 55.0
@export var animatedMovementAmount = 1.0

var timer = cooldown


# Called when the node enters the scene tree for the first time.
func _ready():
	cannonFire.volume_db = decibelLevel
	if is_equal_approx(0.0, startingTime): return
	timer = startingTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0.0:
		# Set some cannon ball variables, reset the timer, and play the cannon sfx.
		var test2 = test.instantiate()
		spawnArea.add_child(test2)
		test2.speed = speed
		test2.survivalTime = survivalTime
		test2.spriteSpinSpeed = spriteSpinSpeed
		test2.direction = 1.0
		test2.canJumpOn = canJumpOn
		timer = cooldown
		cannonFire.play()
		
		# Do two tweens that adjust position and scale, and then do the opposite after the first set of tweens finish.
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		var tweenPos = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tweenPos.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(sprite, "scale:y", 1.0 + (animatedMovementAmount / 10.0), 0.3)
		tweenPos.tween_property(sprite, "position:y", sprite.position.y - animatedMovementAmount, 0.3)
		
		await tween.finished
		
		var tween2 = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		var tweenPos2 = get_tree().create_tween().set_ease(Tween.EASE_OUT)
		tweenPos2.set_trans(Tween.TRANS_ELASTIC)
		tweenPos2.tween_property(sprite, "position:y", sprite.position.y + animatedMovementAmount, 0.3)
		tween2.set_trans(Tween.TRANS_ELASTIC)
		tween2.tween_property(sprite, "scale:y", 1.0, 0.3)
		
