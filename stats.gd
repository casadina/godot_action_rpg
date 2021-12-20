extends Node

export(int) var max_health = 1 setget set_max_health
export(bool) var is_player = false

onready var health: int = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)


func set_max_health(value):
	max_health = value
	if health:
		self.health = int(min(health, max_health))
		emit_signal("max_health_changed", max_health)
	

func set_health(value) -> void:
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func _on_Stats_no_health() -> void:
	if self.get_parent().is_in_group('enemy'):
		self.get_parent().queue_free()
