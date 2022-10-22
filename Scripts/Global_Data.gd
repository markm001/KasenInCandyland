extends Node

var show_fps = true;

var bullet_array = [];

var player_node setget set_player_node, get_player_node;
var e_bullet_container setget set_e_bullet_container, get_e_bullet_container;
var player_bullet_container setget set_player_bullet_container, get_player_bullet_container;

var global_viewport_size setget set_viewport_size, get_viewport_size;
var enemy_container setget set_enemy_container, get_enemy_container;

var raijuu_gauge:int = 0;
var koutai_gauge:int = 1;

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

func reduce_gauge(type:int):
	match type:
		0: #Raijuu
			raijuu_gauge -= 1
		1: #Koutei
			koutai_gauge -= 1
