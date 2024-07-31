extends Node2D

@onready var sprite = $Sprite2D
@onready var deathArea = $"death area"
@onready var stopArea2 = $"stop area2"
@onready var stopArea = $"stop area"
@onready var hitSound = $HitSound

@export var canJumpOn = true
@export var speed = 0.65
@export var direction = 1.0
@export var deathSpeed = 0.2
@export var spriteSpinSpeed = -280.0
@export var animationSpeed = 0.6
@export var spriteScale = Vector2(0.65, 0.65)
@export var survivalTime = 5.0

var dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.scale = Vector2.ZERO
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(sprite, "scale", spriteScale, animationSpeed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.rotation_degrees += spriteSpinSpeed * delta
	global_position += -(global_position - deathArea.global_position).normalized() * speed * delta * direction
	survivalTime -= delta
	if survivalTime <= 0.0: die()


func _on_stop_area_body_entered(body):
	if canJumpOn == false: return
	if body.is_in_group("Player"):
		if dead:return
		if !body.canDie: return
		body.velocity.y = -body.jumpVelocity * 0.75
		body.bounceSfx.play()
		die()

func die():
	if dead: return
	deathArea.set_deferred("monitoring", false)
	stopArea.set_deferred("monitoring", false)
	stopArea2.set_deferred("monitoring", false)
	dead = true
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, deathSpeed)
	await tween.finished
	queue_free()


func _on_death_area_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
		hitSound.play()
		die()


func _on_stop_area_2_body_entered(body):
	if canJumpOn == false: return
	if body.is_in_group("Player"):
		if dead: return
		if !body.canDie: return
		body.velocity.y = body.jumpVelocity * 0.75
		body.bounceSfx.play()
		die()
