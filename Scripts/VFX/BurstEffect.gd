extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished");
	self.frame = 0;
	self.play("BurstEffect")

func _on_animation_finished():
	self.queue_free();
