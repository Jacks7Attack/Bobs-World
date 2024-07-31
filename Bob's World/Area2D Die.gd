extends Area2D

var player
var inArea = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		inArea = true
	elif body.is_in_group("Enemy"):
		body.queue_free()

func _on_body_exited(body):
	if body.is_in_group("Player"):
		inArea = false

func _process(_delta):
	if inArea == true:
		player.die()
