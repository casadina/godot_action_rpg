extends Node

export(int) var max_health = 1
export(bool) var is_player = false

onready var health: int = max_health setget set_health

signal no_health
signal health_changed(value)


func set_health(value):
	health = value
	emit_signal("health_changed", value)
	if health <= 0:
		emit_signal("no_health")


func _on_Stats_no_health():
	if self.get_parent().is_in_group('enemy'):
		self.get_parent().queue_free()
