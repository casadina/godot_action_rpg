extends AnimatedSprite

class_name Effect

func _ready():
	var _finished = self.connect("animation_finished", self, "_on_animation_finished")
	play("Animate")

func _on_animation_finished():
	queue_free()
