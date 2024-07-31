extends StaticBody2D

# Variables that can be modified in the editor.
@onready var sprite := $Sprite
@onready var root := get_tree().root
@onready var player = null
@onready var collision := $Collision
@export var pos1 = Vector2(-55.0, 0.0)
@export var pos2 = Vector2(55.0, 0.0)
@export var belowCompensation = 4.0
# Can do collision checks only works whenever each position only moves on the X axis, otherwise please set to false.
@export var canDoCollisionChecks = true
@export var time = 2.5
@export var cooldown = 2.0
var doCollisionChecks = false 

# _ready() function runs whenever the object exists.
func _ready():
	var foundPlayer = false
	for i in root.get_children():
		for i2 in i.get_children():
			if i2.is_in_group("Player"):
				player = i2
				foundPlayer = true
	if foundPlayer == true:
		doCollisionChecks = true
	pos1 += position
	pos2 += position
	position = pos1
	# While true basically runs in a infinite loop, which is helpful for this case.
	while true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", pos2, time)
		await tween.finished
		await get_tree().create_timer(cooldown).timeout
		
		var tween2 = get_tree().create_tween()
		tween2.tween_property(self, "position", pos1, time)
		await tween2.finished
		await get_tree().create_timer(cooldown).timeout

func _process(_delta):
	if canDoCollisionChecks and doCollisionChecks:
		if player.feetPoint.global_position.y > sprite.global_position.y + belowCompensation:
			collision.disabled = true
		else:
			collision.disabled = false
