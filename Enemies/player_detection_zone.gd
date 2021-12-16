extends Area2D

var player = null


func _on_PlayerDetectionZone_body_entered(body):
	player = body
	

func can_see_player():
	return true if player else false

func _on_PlayerDetectionZone_area_exited(area):
	print('exited')
	player = null
