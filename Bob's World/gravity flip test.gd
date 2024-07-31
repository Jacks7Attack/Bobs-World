extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		body.up_direction.y = 1.0
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(body, "rotation", deg_to_rad(-180.0), 0.5)
		
		if body.is_in_group("Enemy"):
			body.sprite.flip_h = not body.sprite.flip_h
			body.direction = -body.direction
