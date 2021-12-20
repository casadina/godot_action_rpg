extends Area2D

# No typing as we're just checking if there is a player.
var player = null

func can_see_player():
	return player
	
	
func _on_PlayerDetectionZone_body_entered(body) -> void:
	player = body
	
	
func _on_PlayerDetectionZone_body_exited(body) -> void:
	player = null
