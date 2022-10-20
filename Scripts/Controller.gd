extends Node2D

onready var enemy_bullet = $Elements/BulletContainer/Bullet
var bullet_sprite = preload("res://Visuals/Bullet_solid_01.png");

func _ready():
	GlobalData.set_e_bullet_container($Elements/BulletContainer);
	GlobalData.set_player_bullet_container($Elements/PlayerBulletContainer);
