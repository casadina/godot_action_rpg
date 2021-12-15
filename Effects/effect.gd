extends AnimatedSprite

func _ready():
	var finished = self.connect("animation_finished", self, "_on_animation_finished")
	print(finished)
	play("Animate")

func _on_animation_finished():
	queue_free()
