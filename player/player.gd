extends KinematicBody2D

const PLAYER_HURT_SOUND = preload("res://player/player_hurt_sound.tscn")

export(int) var ACCELERATION = 500
export(int) var MAX_SPEED = 80
export(int) var ROLL_SPEED = 125
export(int) var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var knockback := Vector2.ZERO
var state := MOVE
var velocity := Vector2.ZERO
var roll_vector: = Vector2.DOWN
var stats := PlayerStats
var death_error

onready var animation_player := $AnimationPlayer
onready var animation_tree := $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox := $HitboxPivot/SwordHitbox
onready var group_type = add_to_group('player')
onready var hurtbox := $Hurtbox
onready var sound := $AudioStreamPlayer
onready var blink_animation_player = $BlinkAnimationPlayer


func _ready() -> void:
	randomize()
	death_error = stats.connect("no_health", self, "queue_free")
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector


func _process(delta) -> void:
	match state:
		MOVE: 
			move_state(delta)
		ROLL:
			roll_state(	delta)
		ATTACK:
			attack_state(delta)


func move_state(delta) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		hurtbox.start_invincibility(0.5)
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
		
func roll_state(_delta) -> void:
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	move()


func attack_state(_delta) -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	
	
func move() -> void:
	velocity = move_and_slide(velocity)
	
	
func roll_animation_finished() -> void:
	velocity = velocity 
	state = MOVE


func attack_animation_finished() -> void:
	state = MOVE


func _on_Hurtbox_area_entered(_area) -> void:
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var player_hurt_sound = PLAYER_HURT_SOUND.instance()
	get_tree().current_scene.add_child(player_hurt_sound)
	

func _on_Hurtbox_invincibility_started():
	blink_animation_player.play("Start")
	

func _on_Hurtbox_invincibility_ended():
	blink_animation_player.play("Stop")
