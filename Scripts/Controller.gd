extends Node2D

export var case:int = 0;

func _ready():
	GlobalData.set_e_bullet_container($Elements/BulletContainer);
	GlobalData.set_player_bullet_container($Elements/PlayerBulletContainer);
	
	GlobalData.set_enemy_container($Elements/Enemies);
	
	GlobalData.set_viewport_size(get_viewport_rect().size);
	GlobalData.connect("gauge_updated", self, "_on_update_gauge");

func _on_update_gauge(rai_gauge:int, kou_gauge:int):
	if(rai_gauge < 0 || kou_gauge < 0):
		$AnimationPlayer.play("GameOver")
		GlobalData.get_player_node().is_dead = true;

func _input(event):
	if(Input.is_key_pressed(KEY_M)):
		for e in $Elements/Enemies.get_children():
			e.queue_free()
		$SpawnerElement.wave_counter = 1;
		$SpawnerElement.get_node("SpawnerTimer").start();


func _reload_scene():
	GlobalData.reset_properties();
	get_tree().reload_current_scene();
