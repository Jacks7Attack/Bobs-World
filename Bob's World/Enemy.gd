extends CharacterBody2D

# Some variables.
@onready var sprite = $Sprite
@onready var collision = $CollisionShape2D
# Left and Right are raycasts that are used to detect when the enemy hits a wall.
@onready var left = $Left
@onready var right = $Right
@onready var areaCollision = $Area2D/CollisionShape2D
@onready var area = $Area2D
@onready var particles = $"Feet Point/CPUParticles2D"
@onready var footstep = $footstep
@onready var hitSound = $HitSound

@export var flipSpriteOnStart = false
@export var speed = 60.0
@export var direction = 1.0
var defaultSpeed = speed
var didOpposite = false
var lastShapeSize = null
var timerReset = 5.0
var timer = 0.0
var dead = false
var playerOnTop = false
var startingPosition = null
var footstepTimer = 0.3
var timer2 = 0.0
var deadKnown = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var defaultCollisionPosition = null

# Runs on start.
func _ready():
	if flipSpriteOnStart: 
		sprite.flip_h = not sprite.flip_h
	startingPosition = position
	scale = Vector2.ZERO
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)
	particles.emitting = true
	# Play the moving animation.
	sprite.play("move")
	# Set vars that could not be set before.
	lastShapeSize = collision.shape.size
	defaultCollisionPosition = collision.position

# This check would have been done in the _process function, but area's in Godot have no option to force an update.
func _physics_process(_delta):
	# Make a check var and set player on top if the player is on the top of the enemy's head.
	var test = false
	for i in area.get_overlapping_bodies():
		if i.is_in_group("Player"):
			test = true
	
	# Incase there are no bodies on top of the enemy's head, set it to false.
	if test:
		playerOnTop = true
	else:
		playerOnTop = false

func _process(delta):
	# Force raycast updates for accurate raycast results.
	right.force_raycast_update()
	left.force_raycast_update()
	
	# Makes a timer for the footstep.
	if timer2 > 0.0: timer2 -= delta
	
	# If the enemy is dead and it hasn't been known yet, kill the enemy 
	if dead == true and deadKnown == false:
		particles.emitting = false
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(sprite, "scale:y", 0.85, 0.5)
		
		var tween2 = get_tree().create_tween()
		tween2.set_ease(Tween.EASE_OUT)
		tween2.set_trans(Tween.TRANS_ELASTIC)
		tween2.tween_property(sprite, "position:y", -2.333, 0.5)
		sprite.play("idle")
		
		var tween3 = get_tree().create_tween()
		tween3.set_ease(Tween.EASE_OUT)
		tween3.set_trans(Tween.TRANS_ELASTIC)
		var vector2 = Vector2(collision.shape.size.x, collision.shape.size.y / 1.15)
		tween3.tween_property(collision.shape, "size", vector2, 0.5)
		
		var tween4 = get_tree().create_tween()
		tween4.set_ease(Tween.EASE_OUT)
		tween4.set_trans(Tween.TRANS_ELASTIC)
		tween4.tween_property(collision, "position:y", defaultCollisionPosition.y - 2.56666667, 0.5)
		
		deadKnown = true
		timer = timerReset
	
	if timer > 0.0: timer -= delta
	
	# If the enemy's timer is finished and the enemy is dead and the player is not ontop, revive the enemy.
	if timer <= 0.0 and dead == true and playerOnTop == false:
		particles.emitting = true
		dead = false
		deadKnown = false
		areaCollision.disabled = false
		collision.disabled = false
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(sprite, "scale:y", 1.0, 0.5)
		
		var tween2 = get_tree().create_tween()
		tween2.set_ease(Tween.EASE_OUT)
		tween2.set_trans(Tween.TRANS_ELASTIC)
		tween2.tween_property(sprite, "position:y", 0.0, 0.5)
		sprite.play("move")
		
		var tween3 = get_tree().create_tween()
		tween3.set_ease(Tween.EASE_OUT)
		tween3.set_trans(Tween.TRANS_ELASTIC)
		var vector2 = Vector2(lastShapeSize.x, lastShapeSize.y)
		tween3.tween_property(collision.shape, "size", vector2, 0.5)
		
		var tween4 = get_tree().create_tween()
		tween4.set_ease(Tween.EASE_OUT)
		tween4.set_trans(Tween.TRANS_ELASTIC)
		tween4.tween_property(collision, "position:y", defaultCollisionPosition.y, 0.5)
	
	if not is_on_floor():
		velocity += -up_direction * gravity * delta
	
	# If the left is colliding and it is a player, kill the player, if this is the side the enemy is walking, then 
	# turn around.
	if left.is_colliding() and didOpposite == false and dead == false:
		var player = left.get_collider()
		
		if player.is_in_group("Player") and player.canDie == true:
			hitSound.play()
			player.die()
		
		if sprite.flip_h == true:
			sprite.flip_h = not sprite.flip_h
			particles.direction.x = -particles.direction.x
			direction = -direction
			didOpposite = true
	
	# If the right is colliding and it is a player, kill the player, if this is the side the enemy is walking, then 
	# turn around.
	if right.is_colliding() and didOpposite == false and dead == false:
		var player = right.get_collider()
		
		if player.is_in_group("Player") and player.canDie == true:
			hitSound.play()
			player.die()
		
		if sprite.flip_h == false:
			sprite.flip_h = not sprite.flip_h
			particles.direction.x = -particles.direction.x
			direction = -direction
			didOpposite = true
	
	# If there is a direction and the player in not dead, attempt to move in that direction, else attempt to stay
	# still.
	
	if direction and dead == false:
		if timer2 <= 0.0:
			footstep.play()
			timer2 = footstepTimer
		velocity.x = -up_direction.y * direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
	
	# Set didOpposite to false after it is not needed.
	didOpposite = false
	move_and_slide()

func _on_area_2d_body_entered(player: Node2D):
	# Makes sure the body is the player, this is because we need to use player specific vars.
	if player.is_in_group("Player"):
		player.bounceSfx.play()
		player.velocity.y = (-player.up_direction.y * -player.jumpVelocity / 1.5)
		dead = true
