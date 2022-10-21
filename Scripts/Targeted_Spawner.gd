extends Node2D

export(PackedScene) var bullet_scene = preload("res://Scenes/Bullet_Bound.tscn");

export var is_player:bool = false;
export var is_focused:bool = false;
export var bullet_type:int = 1;
export var add_rotation:bool = false;
export var rotation_change:int = 40;
export(float, 0, 1, .001) var bullet_rotation_speed:float = 0;
export(float, 0, 1, .001) var orbital_velocity:float = 0;

export var fire_rate:float = 0.08;
export var spawn_points:int = 2;
export var radius:int = 20;
export var min_rotation:int = 0;
export var max_rotation:int = 360;
export var bullet_velocity:int = 200;
export var acceleration:float = 0.1;


var direction:Vector2 = Vector2();

var spawner_positions:Array = [];

onready var spawnTimer:Timer = $Spawn_Timer;
onready var player_bullet:Texture = preload("res://Visuals/player_bullet.png");

func _ready():
	if(is_player):
		direction = Vector2.UP;
		spawnTimer.wait_time = fire_rate;
	
	else: ## DEBUG: REMOVE LATER!
		spawnTimer.start();


func _process(delta):
	if(!is_player):
		var playerdir = (GlobalData.get_player_node().position - self.global_position).normalized()
		self.rotation_degrees = rad2deg(playerdir.angle())

func calc_positions() -> void:
	spawner_positions.clear();
	for n in range(spawn_points):
		var fraction:float = n / spawn_points;
		var difference:int = max_rotation - min_rotation;
		spawner_positions.append((fraction * difference) + min_rotation);

func instance_bullets(i:int, theta:float):
	var bullet:Area2D = bullet_scene.instance();
	var angle:float = (theta * i) + self.rotation + deg2rad(min_rotation);
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
		
		bullet.velocity = bullet_velocity;
		bullet.direction = Vector2.UP;
		bullet.rotation = angle;
		bullet.acceleration = acceleration;
		
	else:
		GlobalData.get_e_bullet_container().add_child(bullet);
		
		direction.x = cos(angle);
		direction.y = sin(angle);
		
		bullet.global_position = self.global_position + (direction.normalized()) * radius;
		
		bullet.direction = direction;
		bullet.rotation = angle;
		bullet.set_properties(bullet_type, bullet_velocity, acceleration, add_rotation, rotation_change, bullet_rotation_speed, orbital_velocity);
	
	GlobalData.bullet_array.append(bullet);

func _on_Spawn_Timer_timeout():
	spawnTimer.wait_time = fire_rate;
	
	var diff:int = max_rotation - min_rotation;
	var circ:float = deg2rad(diff);
	var t:float = (circ / spawn_points);
	
	for i in range(spawn_points):
		instance_bullets(i, t);
