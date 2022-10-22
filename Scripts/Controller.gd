extends Node2D

export var case:int = 0; 

func _ready():
	GlobalData.set_e_bullet_container($Elements/BulletContainer);
	GlobalData.set_player_bullet_container($Elements/PlayerBulletContainer);
	
	GlobalData.set_enemy_container($Elements/Enemies);
	
	GlobalData.set_viewport_size(get_viewport_rect().size);
	
func _input(event):
	if(Input.is_key_pressed(KEY_M)):
		for e in $Elements/Enemies.get_children():
			e.queue_free()
		$SpawnerElement.init_points(case);
