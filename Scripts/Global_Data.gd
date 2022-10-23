extends Node

var show_fps = true;

var bullet_array = [];

var player_node setget set_player_node, get_player_node;
var e_bullet_container setget set_e_bullet_container, get_e_bullet_container;
var player_bullet_container setget set_player_bullet_container, get_player_bullet_container;

var global_viewport_size setget set_viewport_size, get_viewport_size;
var enemy_container setget set_enemy_container, get_enemy_container;

var raijuu_gauge:int = 4;
var koutai_gauge:int = 5;

var raijuuBurst = preload("res://Scenes/VFX/LightningBurstEffect.tscn");
var kouteiBurst = preload("res://Scenes/VFX/WindBurstEffect.tscn");
var successParticles = preload("res://Scenes/VFX/SuccessParticles.tscn");
var enemyDeathEffect = preload("res://Scenes/VFX/EnemyDeathEffect.tscn")

var kouteiColor:Color = Color(0,1,0);
var active_type setget set_active_type, get_active_type;

signal gauge_updated;
signal type_changed;


func set_e_bullet_container(node:Position2D):
	e_bullet_container = node;
func get_e_bullet_container() -> Position2D:
	return e_bullet_container;

func set_player_bullet_container(node:Position2D):
	player_bullet_container = node;
func get_player_bullet_container() -> Position2D:
	return player_bullet_container;

func set_player_node(node:KinematicBody2D):
	player_node = node;
func get_player_node() -> KinematicBody2D:
	return player_node;

func set_viewport_size(size:Vector2):
	global_viewport_size = size;
func get_viewport_size() -> Vector2:
	return global_viewport_size;
	
func set_enemy_container(node:YSort):
	enemy_container = node;
func get_enemy_container() -> YSort:
	return enemy_container;

func increase_gauge(type:int):
	match type:
		0: #Raijuu
			raijuu_gauge += 1
		1: #Koutei
			koutai_gauge += 1
	emit_signal("gauge_updated", raijuu_gauge, koutai_gauge);

func reduce_gauge(type:int):
	match type:
		0: #Raijuu
			raijuu_gauge -= 1
		1: #Koutei
			koutai_gauge -= 1
	emit_signal("gauge_updated", raijuu_gauge, koutai_gauge);


func get_raijuu_burst_effect() -> Object:
	return raijuuBurst;
func get_koutei_burst_effect() -> Object:
	return kouteiBurst;
func get_success_effect() -> Object:
	return successParticles;


func set_active_type(type:int):
	active_type = type;
	emit_signal("type_changed", active_type);
func get_active_type() -> int:
	return active_type;

func reset_properties():
	raijuu_gauge = 4;
	koutai_gauge = 5;
