extends Node2D

@onready var sfx = $SpikeSound

# Basic kill player code.
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
		sfx.play()
		
