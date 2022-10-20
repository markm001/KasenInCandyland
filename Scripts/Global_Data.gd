extends Node

var show_fps = true;

var bullet_array = [];

var player_node setget set_player_node, get_player_node;
var e_bullet_container setget set_e_bullet_container, get_e_bullet_container;
var player_bullet_container setget set_player_bullet_container, get_player_bullet_container;

func get_e_bullet_container():
	return e_bullet_container;
func set_e_bullet_container(node:Position2D):
	e_bullet_container = node;

func get_player_bullet_container():
	return player_bullet_container;
func set_player_bullet_container(node:Position2D):
	player_bullet_container = node;

func set_player_node(node:KinematicBody2D):
	player_node = node;
func get_player_node():
	return player_node;
