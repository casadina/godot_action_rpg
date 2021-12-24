extends HitBox

class_name Sword

var knockback_vector = Vector2.ZERO
onready var total_damage = damage + self.get_owner().stats.attack
