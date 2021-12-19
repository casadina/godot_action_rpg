extends KinematicBody2D

class_name Enemy

const ENEMY_DEATH_EFFECT = preload("res://effects/enemy_death_effect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = CHASE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var group_type = add_to_group("enemy")


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = player_detection_zone.player
			if player:
				var direction = (global_position.direction_to(player.global_position).normalized())
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)
			

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
	else:
		state = IDLE


func _on_Hurtbox_area_entered(area):
	if area.get_name() == "SwordHitbox":
		knockback = area.knockback_vector * 120
		stats.health -= area.damage


func _on_Stats_no_health():
	print('You batted a bat out of the air like a baseball!')
	var enemy_death_effect = ENEMY_DEATH_EFFECT.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
