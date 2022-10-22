extends Node2D

var viewport_size;
var container;

onready var spawnTimer:Timer = $SpawnerTimer;
onready var spawnTween:Tween = $SpawnerTween;
var EnemyScene:Object = preload("res://Scenes/Enemy.tscn");
var TargetedSpawner:Object = preload("res://Scenes/Targeted_Spawner.tscn");
var BarrageSpawner:Object = preload("res://Scenes/Barrage_Spawner.tscn");
var FieldSpawner:Object = preload("res://Scenes/Field_Spawner.tscn");

export var enemies = 8;
export var spawn_next_enemy_after:float = 1;
export var wait_for_next:bool = true;
export var tween_time:float = 0.8;

var spawners_dict:Dictionary;

func _ready():
	spawners_dict = {
		"Targeted_Spawner":TargetedSpawner,
		"Barrage_Spawner":BarrageSpawner,
		"Field_Spanwer": FieldSpawner}

func init_points(case):
	viewport_size = GlobalData.get_viewport_size();
	container = GlobalData.get_enemy_container();
	
	var x_range = viewport_size.x;
	var y_range = viewport_size.y / 2;
	
	match case:
		0: #X-Range:
			var fract = x_range / enemies;
			for i in range(enemies):
				if(wait_for_next):
					spawnTimer.start(spawn_next_enemy_after);
					yield(spawnTimer, "timeout");
				var enemy:KinematicBody2D = EnemyScene.instance();
				enemy.global_position = Vector2((fract * i) + (fract/2), 50);
				
				container.add_child(enemy);
	
		1: #Y-Range:
			for i in range(enemies):
				if(wait_for_next):
					spawnTimer.start(spawn_next_enemy_after);
					yield(spawnTimer, "timeout");
				var enemy:KinematicBody2D = EnemyScene.instance();
				var random_y:int = rand_range(y_range / enemies, y_range);
				enemy.global_position = Vector2(100,random_y);
				
				container.add_child(enemy);
	
		2: #FIELD:
			for i in range(enemies):
				if(wait_for_next):
					spawnTimer.start(spawn_next_enemy_after);
					yield(spawnTimer, "timeout");
				var enemy:KinematicBody2D = EnemyScene.instance();
				var random_x:int = rand_range(x_range / enemies, x_range);
				var random_y:int = rand_range(y_range / enemies, y_range);
				#REPLACE WITH rand-CORNERS & ADD SEED
				enemy.global_position = Vector2(random_x,0);
				container.add_child(enemy);
				
				
				
				var spawn_position = Vector2(random_x,random_y);
				tween_instance(enemy, spawn_position)
				
				var spawnerInstance = set_spawner_properties("T");
				GlobalData.get_player_node().add_child(spawnerInstance);
				

func set_spawner_properties(key:String) -> Object:
	var spawner_data:Dictionary = EnemyData.spawner_data.get(key);
	print(spawner_data)
	
	# Set instance type:
	var spawnerInstance:Node2D = spawners_dict.get(spawner_data.get("spawnerType")).instance();
	
	# Set Properties:
	for key in spawner_data:
		var value = spawner_data.get(key);
		
		spawnerInstance.set(key, value);
	
	return spawnerInstance;

func tween_instance(instance:KinematicBody2D, final_pos:Vector2):
	spawnTween.interpolate_property(instance, "global_position", instance.global_position, final_pos,tween_time,Tween.TRANS_EXPO);
	spawnTween.start();
