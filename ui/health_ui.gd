extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var label = $Label

func set_hearts(value):
	clamp(value, 0, max_hearts)
	if label:
		label.text = "HP = " + str(value)


func set_max_hearts(value):
	max_hearts = max(value, 1)
	

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	
