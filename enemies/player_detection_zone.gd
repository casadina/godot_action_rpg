extends Area2D

var player = null

func can_see_player():
	return player
	
	
func _on_PlayerDetectionZone_body_entered(body):
	player = body
	
	
func _on_PlayerDetectionZone_body_exited(body):
	print(body)
	player = null
