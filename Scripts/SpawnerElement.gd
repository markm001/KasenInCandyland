extends Node2D

var viewport_size;
var container;

onready var spawnTimer:Timer = $SpawnerTimer;
onready var spawnTween:Tween = $SpawnerTween;
var EnemyScene:Object = preload("res://Scenes/Enemy.tscn");
var TargetedSpawner:Object = preload("res://Scenes/Targeted_Spawner.tscn");
var BarrageSpawner:Object = preload("res://Scenes/Barrage_Spawner.tscn");
var FieldSpawner:Object = preload("res://Scenes/Field_Spawner.tscn");

export var spawn_next_enemy_after:float = 1;
export var wait_for_next:bool = true;
export var tween_time:float = 0.8;

var wave_counter = 1;
var sequence_counter = 1;

var wave_data:Dictionary;
var sequence_data:Dictionary;

var spawners_dict:Dictionary;

func _ready():
	spawners_dict = {
		"Targeted_Spawner":TargetedSpawner,
		"Barrage_Spawner":BarrageSpawner,
		"Field_Spanwer": FieldSpawner}
	wave_data = MechanicsData.wave_data;

func get_current_wave() -> void:
	if(wave_data.has(wave_counter)):
		var wave:Dictionary = wave_data.get(wave_counter);
		get_current_sequence(wave);
	else:
		spawnTimer.stop();

func get_current_sequence(enemy_sequence:Dictionary) -> void:
	var sequence_data:Array = enemy_sequence.get(sequence_counter);
		
	var spawner_type = sequence_data[0];
	var enemy_amount = sequence_data[1];
	var spawn_range = sequence_data[2];
	var bullet_type = sequence_data[3];
	spawn_next_enemy_after = sequence_data[4];
	var barrage_lifetime = sequence_data[5];
	
	spawnTimer.start(spawn_next_enemy_after);
	init_points(spawn_range, enemy_amount, spawner_type, barrage_lifetime, bullet_type);
	
	print(str(sequence_counter), spawner_type, str(enemy_amount), spawn_range, str(spawn_next_enemy_after));
	
	#Increment Wave after sequences finish:
	if(sequence_counter == enemy_sequence.keys().size()):
		wave_counter += 1;
		sequence_counter = 1;
	else:
		sequence_counter += 1;

func init_points(pos_range:String, enemies:int, spawner_type:String, barrage_lifetime:float, bullet_type:int):
	viewport_size = GlobalData.get_viewport_size();
	container = GlobalData.get_enemy_container();
	
	var x_range = viewport_size.x;
	var y_range = viewport_size.y / 2;
	
	match pos_range:
		"X-RANGE":
			var fract = x_range / enemies;
			for i in range(enemies):
				if(wait_for_next):
					spawnTimer.start(spawn_next_enemy_after);
					yield(spawnTimer, "timeout");
				var enemy:KinematicBody2D = EnemyScene.instance();
				
				var screen_side = get_either_side(y_range);
				
				var spawn_position = Vector2((fract * i) + (fract/2), 50);
				enemy.global_position = check_closest_corner(spawn_position);
				enemy.barrage_lifetime = barrage_lifetime;
				container.add_child(enemy);
				
				enemy.direction = (spawn_position - enemy.global_position).normalized();
				set_position_enemy(enemy, spawn_position, spawner_type, bullet_type);
	
		"Y-RANGE":
			for i in range(enemies):
				if(wait_for_next):
					spawnTimer.start(spawn_next_enemy_after);
					yield(spawnTimer, "timeout");
				var enemy:KinematicBody2D = EnemyScene.instance();
				var random_y:int = rand_range(y_range / enemies, y_range);
				
				var screen_side = get_either_side(x_range);
				var spawn_position = Vector2(screen_side,random_y);
				enemy.global_position = check_closest_corner(spawn_position);
				enemy.barrage_lifetime = barrage_lifetime;
				
				container.add_child(enemy);
				
				enemy.direction = (spawn_position - enemy.global_position).normalized();
				set_position_enemy(enemy, spawn_position, spawner_type, bullet_type);
				
	
		"FIELD":
			for i in range(enemies):
				if(wait_for_next):
					spawnTimer.start(spawn_next_enemy_after);
					yield(spawnTimer, "timeout");
				var enemy:KinematicBody2D = EnemyScene.instance();
				var random_x:int = rand_range(x_range / enemies, x_range);
				var random_y:int = rand_range(y_range / enemies, y_range);
				
				#REPLACE WITH rand-CORNERS & ADD SEED
				var spawn_position = Vector2(random_x,random_y);
				enemy.global_position = check_closest_corner(spawn_position);
				enemy.barrage_lifetime = barrage_lifetime;
				container.add_child(enemy);
				
				enemy.direction = (spawn_position - enemy.global_position).normalized();
				set_position_enemy(enemy, spawn_position, spawner_type, bullet_type);

func get_either_side(screen:int) -> int:
	var fraction:float = screen / 4;
	var b = randi()%2
	var x:int = int(fraction); # |. x . x .|
	
	if(b):
		x = int(fraction * 3);
	
	return x;

func check_closest_corner(final_pos:Vector2) -> Vector2:
	var origin = Vector2.ZERO;
	
	var diffX = viewport_size.x - final_pos.x;
	var diffY = viewport_size.y - final_pos.y;
	if(diffX < final_pos.x):
		origin.x = viewport_size.x;
	if(diffY < final_pos.y):
		origin.y = viewport_size.y;
	
	return origin;
	

func set_position_enemy(enemy:KinematicBody2D, spawn_position:Vector2, spawner_type:String, bullet_type:int) -> void:
	var spawnerInstance = set_spawner_properties(spawner_type);
	spawnerInstance.set_bullet_type(bullet_type);
	
	enemy.get_node("SpawnerContainer").add_child(spawnerInstance);
	tween_instance(enemy, spawn_position)

func set_spawner_properties(key:String) -> Node2D:
	var spawner_data:Dictionary = EnemyData.spawner_data.get(key);
	
	# Set instance type:
	var spawnerInstance:Node2D = spawners_dict.get(spawner_data.get("spawnerType")).instance();
	
	# Set Properties:
	for key in spawner_data:
		var value = spawner_data.get(key);
		
		spawnerInstance.set(key, value);
	
	return spawnerInstance;

func tween_instance(instance:KinematicBody2D, final_pos:Vector2):
	spawnTween.interpolate_property(instance, "global_position", instance.global_position, final_pos,tween_time,Tween.EASE_IN);
	spawnTween.start();


func _on_SpawnerTween_tween_completed(instance:Object, key:NodePath):
	instance.set_active()


func _on_SpawnerTimer_timeout():
	print("Sequence finished!");
	get_current_wave();
