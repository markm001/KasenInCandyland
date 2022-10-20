extends Node2D

export(PackedScene) var bullet_scene = preload("res://Scenes/Bullet_Timed.tscn");
var parent_node:Position2D;

export var is_player:bool = false;
export var fire_rate:float = 0.4;
export var spawn_points:int = 2;
export var min_rotation:int = 0;
export var max_rotation:int = 360;
export var bullet_velocity:int = 3000;

var direction:Vector2 = Vector2();

var spawner_positions:Array = [];

onready var spawnTimer = $Spawn_Timer;

func _ready():
	if(is_player):
		parent_node = get_node("/root/World/ViewportContainer/Viewport/Game_View/Elements/PlayerBulletContainer");
		direction = Vector2(1,0);

func _process(delta):
	if(!is_player):
		pass #Non Player Direction(Spin/Face) Logic

func calc_positions():
	for n in range(spawn_points):
		var fraction:float = n / spawn_points;
		var difference:int = max_rotation - min_rotation;
		spawner_positions.append((fraction * difference) + min_rotation);

func instance_bullets():
	if(is_player):
		var bullet:Area2D = bullet_scene.instance();
		GlobalData.get_player_bullet_container().add_child(bullet);
		
		bullet.global_position = self.global_position + Vector2(0,10);
		bullet.rotation = deg2rad(90);
		bullet.velocity = 100;
		

func _on_Spawn_Timer_timeout():
	spawnTimer.wait_time = fire_rate;
	instance_bullets();
	
	print("BULLET SPAWNED");
