extends Node2D

export(int) var wander_range = 32

onready var start_position = global_position
onready var target_position = global_position
onready var timer = $Timer

var new_pos: Vector2


func _ready():
	update_target_position()


func random_position():
	return rand_range(-wander_range, wander_range)


func update_target_position():
	var x = random_position()
	var y = random_position()
	var target_vector = Vector2(x, y)
	target_position = start_position + target_vector
	return target_position
	

func get_time_left():
	return timer.time_left
	
	
func set_wander_timer(duration):
	timer.start(duration)


func _on_Timer_timeout():
	target_position = update_target_position()
