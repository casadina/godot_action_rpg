extends KinematicBody2D

class_name Enemy

const ENEMY_DEATH_EFFECT = preload("res://effects/enemy_death_effect.tscn")

export(int) var ACCELERATION = 300
export(int) var MAX_SPEED = 50
export(int) var FRICTION = 200
export(int) var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var state := CHASE
var target_distance
var collision_timer: float = 0
var wait_time := 0.3
var wander_states := [IDLE, WANDER]

onready var sprite := $AnimatedSprite
onready var stats := $Stats
onready var player_detection_zone := $PlayerDetectionZone
onready var group_type = add_to_group("enemy")
onready var hurtbox := $Hurtbox
onready var soft_collision := $SoftCollision
onready var wander_controller := $WanderController
onready var animation_player := $AnimationPlayer

func _ready():
	state = pick_random_state(wander_states)


func _physics_process(delta) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	collision_timer += delta
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			seek_player()
			var target_position = wander_controller.target_position
			set_direction_velocity(target_position, delta)
			
			target_distance = global_position.distance_to(target_position)
			if target_distance <= WANDER_TARGET_RANGE:
				idle_or_wander()
		CHASE:
			var player = player_detection_zone.player
			if player:
				set_direction_velocity(player.global_position, delta)

			else:
				state = IDLE
	if collision_timer >= wait_time:
		velocity = move_and_slide(velocity + soft_collision.get_push_vector())
		state = IDLE
		collision_timer = 0
	else:
		velocity = move_and_slide(velocity)


func set_direction_velocity(target, delta):
	var direction = global_position.direction_to(target)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	return velocity


func seek_player() -> void:
	if player_detection_zone.can_see_player() && is_instance_valid(player_detection_zone.can_see_player()):
		state = CHASE
	else:
		idle_or_wander()
		
		
func pick_random_state(state_list) -> int:
	state_list.shuffle()
	return state_list.pop_front()
	

func idle_or_wander() -> void:
	if wander_controller.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wander_controller.set_wander_timer(rand_range(1, 3))


func _on_Hurtbox_area_entered(area) -> void:
	if area.get_name() == "SwordHitbox":
		knockback = area.knockback_vector * 120
		stats.health -= area.damage
		hurtbox.create_hit_effect()
		hurtbox.start_invincibility(0.4)


func _on_Stats_no_health() -> void:
	print('You batted a bat out of the air like a baseball!')
	var enemy_death_effect = ENEMY_DEATH_EFFECT.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position


func _on_Hurtbox_invincibility_started() -> void:
	animation_player.play_blink()


func _on_Hurtbox_invincibility_ended() -> void:
	animation_player.stop_blink()
