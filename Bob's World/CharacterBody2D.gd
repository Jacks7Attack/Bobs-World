extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var particles = $"Feet Point"/CPUParticles2D
@onready var chat = $".."/Camera2D/CanvasLayer/Dialogue
@onready var rect = $".."/Camera2D/CanvasLayer2/ColorRect
@onready var postProcess = $".."/Camera2D/PostProcess
@onready var music = $".."/Camera2D/Music
@onready var cam = $".."/Camera2D

var speed = 80.0
var canEnterMenu = true
var noMusic = false
# The can jump cancel var is there for the option to be able to be toggled in the menu.
var canJumpCancel = true
var direction = Vector2.ZERO
var slide = false
var canResume = true
var movementAccel = 4
var moving = false
var path = "user://musicAllowed"
var path2 = "user://jumpCancelAllowed"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var lastMusicVolume = []
var setThing = false

func loadData():
	if FileAccess.file_exists(path) and FileAccess.file_exists(path2):
		var file = FileAccess.open(path, FileAccess.READ)
		var file2 = FileAccess.open(path2, FileAccess.READ)
		
		noMusic = file.get_var()
		canJumpCancel = file2.get_var()
	
func saveData():
	var file = FileAccess.open(path, FileAccess.WRITE)
	var file2 = FileAccess.open(path2, FileAccess.WRITE)

	file.store_var(noMusic)
	file2.store_var(canJumpCancel)

func stopMusic():
	if canResume == false: return
	for i: AudioStreamPlayer in music.get_children():
		if setThing == false: lastMusicVolume.append(i.volume_db)
		i.volume_db = -80.0
	setThing = true

func deafenMusic():
	if noMusic == true: return
	if canResume == false: return
	for i: AudioStreamPlayer in music.get_children():
		var tween = get_tree().create_tween()
		if setThing == false: lastMusicVolume.append(i.volume_db)
		tween.tween_property(i, "volume_db", -7.0, 1.5)
	setThing = true

func deafenMusicNow():
	if noMusic == true: return
	if canResume == false: return
	for i: AudioStreamPlayer in music.get_children():
		if setThing == false: lastMusicVolume.append(i.volume_db)
		i.volume_db = -12.0
	setThing = true

func normalizeMusic():
	if noMusic == true: return
	if canResume == false or setThing == false: return
	var number = 0
	for i: AudioStreamPlayer in music.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(i, "volume_db", lastMusicVolume[number], 1.5)
		print(lastMusicVolume[number])
		number += 1

func normalizeMusicNow():
	if noMusic == true: return
	if canResume == false or setThing == false: return
	var number = 0
	for i: AudioStreamPlayer in music.get_children():
		i.volume_db = lastMusicVolume[number]
		number += 1

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveData()
		get_tree().quit()

func transparent():
	rect.visible = true
	var tween = get_tree().create_tween()
	var color2 = Color(0, 0, 0, 0)
	tween.tween_property(rect, "modulate", color2, 2.0)

func doVisible():
	rect.visible = true
	var tween = get_tree().create_tween()
	var color2 = Color(0, 0, 0, 1)
	tween.tween_property(rect, "modulate", color2, 2.0)

func _ready():
	loadData()
	if noMusic == true:
		stopMusic()
	sprite.play("idle")
	transparent()


func _process(delta):
	if noMusic:
		stopMusic()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var directionX = -Input.get_action_strength("left") + Input.get_action_strength("right")
	var directionY = -Input.get_action_strength("up") + Input.get_action_strength("down")
		
	var directionInput = Vector2(directionX, directionY).normalized()
	if not directionInput.is_equal_approx(Vector2.ZERO) and chat.visible == false:
		if directionX < 0: 
			sprite.flip_h = true
			particles.direction = Vector2(-1, particles.direction.y)
		elif directionX > 0: 
			sprite.flip_h = false
			particles.direction = Vector2(-1, particles.direction.y)
		if moving == false:
			sprite.play("walk")
			particles.emitting = true
		moving = true
	else:
		if moving == true:
			sprite.play("idle")
			particles.emitting = false
		moving = false
	
	if slide == true and chat.visible == false: direction = lerp(direction, directionInput, delta * movementAccel)
	elif chat.visible == false: direction = directionInput
	else: direction = Vector2.ZERO
	
	if direction:
		if directionX < 0: sprite.flip_h = true
		elif directionX > 0: sprite.flip_h = false
		velocity = direction * speed
	else:
		velocity = Vector2(move_toward(velocity.x, 0, speed), move_toward(velocity.y, 0, speed))

	move_and_slide()
