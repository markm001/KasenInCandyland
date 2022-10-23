extends Node2D

enum type {
	DRAGON, TIGER
}
export var bullet_type:int = 0;

export var speed_up:bool = false;

export(int, 1, 80) var spawnPoints:int = 1;
export var spawnRate:float = 0.4;
export var radius:int = 10;
export var rotating_spawner:bool = true;
export var face_player:bool = false;
export var facing_speed:float = 0.3;
export var rotation_speed:int = 10;

export var minRotation:int = 90;
export var maxRotation:int = 360;

export (PackedScene) var bullet_scene = preload("res://Scenes/Bullet_Timed.tscn");
export var parentToSpawner:bool = false;

export var velocity:int = 200;
export var acceleration:float = 0;
export var lifetime:float = 5.0;
export var add_rotation:bool = false;
export var rotation_change:int = 40;
export(float, 0, 1, .001) var bullet_rotation_speed:float = 0;
export(float, 0, 1, .001) var orbital_velocity:float = 0;

export var change_direction:bool = false;
export var special_direction:Vector2 = Vector2();
export var special_time:float = 0;

export var amplitude:float = 0.9;
export var extension:int = 100;
export(int, -40, 40, 1) var magnitude:int = 0;
export(int, 0, 720, 1) var height:int = 0;
export(int, -360, 360, 10) var dist_bullet_rotation = -90;
export var random_rotation = false;
var j = 0;
	
func _process(delta):
	if(speed_up):
		speed_up_bullets(delta);

func _on_Spawn_Timer_timeout():
	$SpawnTimer.wait_time = spawnRate;
	_distribute_bullets();

func speed_up_bullets(delta):
	lifetime = lerp(lifetime, 2, delta * 2);
	velocity = lerp(velocity, velocity + 40, delta*2);
	spawnRate = lerp(spawnRate, 0.08, delta);

func _distribute_bullets():
	j += 1
	if(j > spawnPoints):
		j = 0;
	else:
#	for i in range(spawnPoints):
		var random_coord:Vector2 = Vector2();
		var fraction:float = GlobalData.get_viewport_size().x / spawnPoints
		
		random_coord.x = fraction * j;
		random_coord.y = (extension * sin(j * amplitude) + (j * magnitude)) + height;
		
		var bullet:Area2D = bullet_scene.instance();
		
		if(bullet_type): # 1 = Koutei
			bullet.modulate_Sprite_Color(GlobalData.kouteiColor);
		
		GlobalData.get_e_bullet_container().add_child(bullet);
		GlobalData.bullet_array.append(bullet);
		
		bullet.global_position = random_coord;
		
		var randMin:float = rand_range(deg2rad(minRotation), deg2rad(maxRotation))
		var theta:float = rand_range(randMin, deg2rad(maxRotation));
		var angle:float = (theta * j) + self.rotation + randMin;
		var direction:Vector2 = Vector2(cos(angle), sin(angle));
		
		bullet.direction = direction;
		if(random_rotation):
			bullet.rotation = angle;
		else:
			bullet.rotation = deg2rad(dist_bullet_rotation);

		var hover_vel:int = 20;
		var hover_accel:float = 1;
		var orbital_hover:float = 0.03;
		var enable_hover_rotation:bool = true;
		var hover_rotation_change:float = 0.2; 
		bullet.set_properties(bullet_type, hover_vel, hover_accel, lifetime, enable_hover_rotation, hover_rotation_change, bullet_rotation_speed, orbital_hover);
		
		bullet.append_special(special_direction, rand_range(special_time, special_time + 0.5));

func set_bullet_type(type:int):
	self.bullet_type = type;

func enable():
	$SpawnTimer.start();

func disable():
	$SpawnTimer.stop();
