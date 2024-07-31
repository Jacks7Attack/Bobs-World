extends StaticBody2D

# Entire script currently deals with moving the eye to face the player and rotating the object.
@onready var eye = $Eye
@onready var eyePos = eye.position
@onready var base = $Base
@onready var deathArea = $"Destroy Area"
@export var health = 3
var lastHealth = health
var immune = false
var player
var playerFound = false
var spinSpeedPerSecond = 50.0


# Called when the node enters the scene tree for the first time.
func _ready():
	# Deals with getting the player by searching children (remember, the root includes the level and autoload scripts, that's why we search all of the children).
	for i in get_tree().root.get_children():
		for i2 in i.get_children():
			if i2.is_in_group("Player"):
				player = i2
				playerFound = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Rotate the body every frame, not finished yet.
	#if rotation_degrees >= 360.0: rotation_degrees = 0.0
	#rotation_degrees = rotation_degrees + (delta * spinSpeedPerSecond)
	
	# Makes the eye stay at the same rotation relative to the parent, feel free to uncomment it if you want.
	#eye.rotation = -rotation
	
	# Deals with making the eye look at the player if the player is found.
	if playerFound:
		var magnitude = position - player.position as Vector2
		magnitude = -magnitude.normalized() * 1.5
		eye.position = eyePos + magnitude


func _on_destroy_area_body_entered(body):
	if immune: return
	
	if body.is_in_group("Player"):
		player.velocity.y = -player.jumpVelocity
		player.bounceSfx.play()
		health -= 1
		immune = true
		lastHealth = health
		var color = Color(1.6, 1.0, 1.0, 1.0)
		var lastself_modulate = base.self_modulate
		base.self_modulate = color
		print(base.self_modulate)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + Vector2(200.0, 0.0), 2.0)
		await get_tree().create_timer(0.3).timeout
		base.self_modulate = lastself_modulate
		if health <= 0:
			pass
		immune = false
	
