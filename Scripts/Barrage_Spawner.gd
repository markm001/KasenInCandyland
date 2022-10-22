extends Node2D

enum type {
	Raijuu, Koutei
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
onready var displacementTween = $DisplacementTween;

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

func _ready():
	# ## DEBUG: REMOVE LATER!
	$SpawnTimer.start();
	
func _process(delta):
	if(rotating_spawner):
		var updatedRotation:float = self.rotation_degrees + rotation_speed * delta;
		self.rotation_degrees = fmod(updatedRotation,360);
		
	if(speed_up):
		speed_up_bullets(delta);


func _on_Spawn_Timer_timeout():
	$SpawnTimer.wait_time = spawnRate;
	_spawn_bullets();

func _spawn_bullets() -> void:
	var diff:int = maxRotation - minRotation;
	
	var circ:float = deg2rad(diff);
	var t:float = (circ / spawnPoints);
	
	for i in range(spawnPoints):
		var bullet:Area2D = instance_bullet(i, t);
		
		if(change_direction):
			bullet.append_special(special_direction, rand_range(special_time, special_time + 0.5));
		
		GlobalData.bullet_array.append(bullet);


func instance_bullet(i:int, theta:float) -> Area2D:
	var bullet:Area2D = bullet_scene.instance();
	
	if(parentToSpawner):
		$SpawnContainer.add_child(bullet);
	else:
		GlobalData.get_e_bullet_container().add_child(bullet);
	
	var angle:float = (theta * i) + self.rotation + deg2rad(minRotation); # 0-6.290 == 360°
	
	if(change_direction):
			var randMin = rand_range(deg2rad(minRotation), deg2rad(maxRotation))
			theta = rand_range(randMin, deg2rad(maxRotation));
			angle = (theta * i) + self.rotation + randMin;
	
	var direction:Vector2 = Vector2();
	direction.x = cos(angle);
	direction.y = sin(angle);
	
	bullet.global_position = self.global_position + (direction.normalized() * radius);
	
	bullet.direction = direction;
	
	bullet.rotation = angle;
	
	bullet.set_properties(bullet_type, velocity, acceleration, lifetime, add_rotation, rotation_change, bullet_rotation_speed, orbital_velocity);
	
	return bullet;

func speed_up_bullets(delta):
	lifetime = lerp(lifetime, 2, delta * 2);
	velocity = lerp(velocity, velocity + 40, delta*2);
	spawnRate = lerp(spawnRate, 0.08, delta);


func displace_spawner(point:Vector2, time:float) -> void:
	displacementTween.interpolate_property(self, "global_position", global_position, point, time,Tween.TRANS_LINEAR);
	displacementTween.start();

func _on_DisplacementTween_tween_all_completed():
	position = Vector2.ZERO;
