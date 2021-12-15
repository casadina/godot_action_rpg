extends KinematicBody2D

var knockback = Vector2.ZERO

onready var stats = $Stats

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	if area.get_name() == "SwordHitbox":
		knockback = area.knockback_vector * 120
		stats.health -= area.damage

func _on_Stats_no_health():
	print('You batted a bat out of the air like a baseball!')
