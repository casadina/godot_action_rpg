extends Node2D

onready var stats = $Stats

func create_grass_effect():
	var GrassEffect = load("res://Effects/grass_effect.tscn")
	var grass_effect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grass_effect)
	grass_effect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	if area.get_name() == "SwordHitbox":
		create_grass_effect()
		stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
