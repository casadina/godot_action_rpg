extends Node

export(int) var max_health = 1
onready var health: int = max_health setget set_health

signal no_health


func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")


func _on_Stats_no_health():
	self.get_parent().queue_free()
