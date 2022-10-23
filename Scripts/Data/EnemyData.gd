extends Node

var spawner_data:Dictionary = {};

## DECLARE ENEMY DATA - MechanicsData RELATION HERE!
## -- EnemyType : {SpawnerType, Params} ##
func _ready():
	
	var wheel_enemy = {
#		"type" : "Wheel",
		"spawnerType": "Barrage_Spawner",
		"spawnRate": 0.1,
		"radius": 10,
		"spawnPoints":4,
		"velocity": 3,
		"acceleration": 5,
		"rotation_speed": 40
	};
	var fork_enemy = {
#		"type" : "Fork",
		"spawnerType": "Targeted_Spawner",
		"spawnRate": 0.2,
		"spawnPoints":2,
		"velocity": 180,
		"acceleration": 0.9,
		"minRotation": 300,
		"add_rotation": true,
		"rotation_change": 40
	};
	var t_enemy = {
#		"type" : "T",
		"spawnerType": "Targeted_Spawner",
		"spawnRate": 0.2,
		"spawnPoints":3,
		"velocity": 180,
		"acceleration": -0.9,
		"minRotation": 80
	};
	var star_enemy = {
#		"type" : "Star",
		"spawnerType": "Barrage_Spawner",
		"spawnRate": 0.1,
		"spawnPoints":6,
		"velocity": 50,
		"acceleration": 3.5,
		"rotation_speed": 40
	};
	var oneEighty_enemy = {
#		"type" : "OneEighty",
		"spawnerType": "Barrage_Spawner",
		"spawnRate": 0.15,
		"spawnPoints":5,
		"velocity": 250,
		"acceleration": 0.5
	};
	var singleTarget_enemy = {
#		"type" : "SingleTarget",
		"spawnerType": "Targeted_Spawner",
		"spawnRate": 0.2,
		"spawnPoints":1,
		"velocity": 300,
		"acceleration": 0.3
	};
	var tris_enemy = {
#		"type" : "Tris",
		"spawnerType": "Barrage_Spawner",
		"spawnRate": 0.8,
		"spawnPoints":4,
		"velocity": 200,
		"acceleration": 0.1
	};
	
	spawner_data = {
		"WHEEL": wheel_enemy,
		"FORK": fork_enemy,
		"T": t_enemy,
		"STAR": star_enemy,
		"ONEEIGHTY": oneEighty_enemy,
		"SINGLET": singleTarget_enemy,
		"TRIS": tris_enemy
	};
