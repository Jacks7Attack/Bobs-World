extends Area2D

@export var intendedUpDirection = Vector2.UP

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.saveCheckpoint(position)
		body.up_direction = intendedUpDirection
		if intendedUpDirection.is_equal_approx(Vector2.UP): 
			var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_QUAD)
			tween.tween_property(body, "rotation", deg_to_rad(0.0), 0.0)
		else:
			var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_QUAD)
			tween.tween_property(body, "rotation", deg_to_rad(180.0), 0.0)
		body.saveUpDirection()
		
		
