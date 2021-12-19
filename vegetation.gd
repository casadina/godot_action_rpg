extends Node2D

# Right now all details are specific to grass_effect.
# Make sure to overwrite details if that is not wanted.

const GRASS_EFFECT = preload("res://effects/grass_effect.tscn")

onready var stats = $Stats


func create_grass_effect():
	var grass_effect = GRASS_EFFECT.instance()
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position


func _on_Hurtbox_area_entered(area):
	print('ok')
	if area.get_name() == "SwordHitbox":
		create_grass_effect()
		stats.health -= area.damage


func _on_Stats_no_health():
	print('Oh no, you destroyed some lovely grass!')
