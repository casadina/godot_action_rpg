extends Container

var hearts = 4 setget set_hearts
var max_hearts: = 4 setget set_max_hearts

var connect_health
var connect_max_health

onready var heart_ui_full = $HeartUIFull
onready var heart_ui_empty = $HeartUIEmpty


func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full:
		heart_ui_full.rect_size.x = hearts * 15
	if hearts == 0:
		# Below not necessary if TextureRect set to Expand
		# heart_ui_full.hide()
		print('ded')


func set_max_hearts(value) -> void:
	max_hearts = int(max(value, 1))
	if heart_ui_empty:
		heart_ui_empty.rect_size.x = max_hearts * 15
		
		
func _ready() -> void:
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	connect_health = PlayerStats.connect("health_changed", self, "set_hearts")
	connect_max_health = PlayerStats.connect("max_health_changed", self, "set_max_hearts")
