extends Node

## MECHANICS ARE DECLARED HERE: ## - Reference Spawner Types##

var wave_data = {};

func _ready():
	var wave1 = {
		# SEQUENCE:["TYPE", amount, bullet_type, "SpawnRange", delay, barrage_lifetime] 
		1:["WHEEL", 4, "X-RANGE", 0, 0.02, 0.8],
		2:["SINGLET", 2, "Y-RANGE", 1, 0.4, 1],
		3:["SINGLET", 2, "X-RANGE", 1, 1.2, 1],
		4:["FORK", 2, "Y-RANGE", 1, 1.6, 1]
	};
	
	wave_data = {1: wave1};
