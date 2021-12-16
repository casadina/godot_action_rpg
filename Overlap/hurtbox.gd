extends Area2D

# Plan below to add multiple different hit effect types.
const HIT_EFFECT = preload("res://Effects/hit_effect.tscn")
var hit_types = {1: HIT_EFFECT}
var hit_effect = hit_types[1]

export(bool) var show_hit = true


func _on_Hurtbox_area_entered(area):
	if get_parent().is_in_group("enemy"):
		var effect = hit_effect.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
