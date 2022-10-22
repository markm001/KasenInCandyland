extends Node2D

export(PackedScene) var bullet_scene = preload("res://Scenes/Bullet_Bound.tscn");

export var is_player:bool = false;
export var is_focused:bool = false;
export var bullet_type:int = 1;
export var add_rotation:bool = false;
export var rotation_change:int = 40;
export(float, 0, 1, .001) var bullet_rotation_speed:float = 0;
export(float, 0, 1, .001) var orbital_velocity:float = 0;

export var spawnRate:float = 0.08;
export var spawn_points:int = 2;
export var radius:int = 20;
export var minRotation:int = 0;
export var maxRotation:int = 360;
export var velocity:int = 200;
export var acceleration:float = 0.1;
export var target_player_pos:bool = false;
export var target_player_dir:bool = true;

var direction:Vector2 = Vector2();

var spawner_positions:Array = [];

onready var spawnTimer:Timer = $Spawn_Timer;
onready var player_bullet:Texture = preload("res://Visuals/player_bullet.png");
export var offset = 0;
func _ready():
	if(is_player):
		direction = Vector2.UP;
		spawnTimer.wait_time = spawnRate;
	
	else: ## DEBUG: REMOVE LATER!
		target_player_dir = true;
		spawnTimer.start();


func instance_bullets(i:int, theta:float):
	var bullet:Area2D = bullet_scene.instance();
	var angle:float = (theta * i) + self.rotation + deg2rad(minRotation);
	
	if target_player_dir:
		var diff = deg2rad(maxRotation - minRotation) / spawn_points;
		
		var playerdir = (GlobalData.get_player_node().position - self.global_position).normalized();
		angle = (theta * i) + (playerdir.angle() - diff);
	
	var direction:Vector2 = Vector2.ZERO;
	
	if(is_player):
		GlobalData.get_player_bullet_container().add_child(bullet);
		
		if(is_focused):
			var t = ((PI/2) / spawn_points);
			angle = (t * i) + self.rotation + deg2rad(70);
			angle = -angle;
		
		direction.x = cos(angle);
		direction.y = sin(angle);
		
		bullet.global_position = self.global_position + (direction.normalized()) * radius;
		
		bullet.velocity = velocity;
		bullet.direction = Vector2.UP;
		bullet.rotation = angle;
		bullet.acceleration = acceleration;
		
	else:
		GlobalData.get_e_bullet_container().add_child(bullet);
		
		direction.x = cos(angle);
		direction.y = sin(angle);
		
		bullet.global_position = self.global_position + (direction.normalized()) * radius;
		
		if(target_player_pos):
			direction = (GlobalData.get_player_node().position - self.global_position).normalized();
		
		bullet.direction = direction;
		bullet.rotation = angle;
		bullet.set_properties(bullet_type, velocity, acceleration, add_rotation, rotation_change, bullet_rotation_speed, orbital_velocity);
	
	GlobalData.bullet_array.append(bullet);

func _on_Spawn_Timer_timeout():
	spawnTimer.wait_time = spawnRate;
	
	var diff:int = maxRotation - minRotation;
	var circ:float = deg2rad(diff);
	var t:float = (circ / spawn_points);
	
	for i in range(spawn_points):
		instance_bullets(i, t);
