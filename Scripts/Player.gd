extends KinematicBody2D

var absorb_type:int = 0;
var is_focused:bool = false;
var is_firing:bool = false;
export var speed = 300;
export var focus_speed = 150;
export var friction = 1800;
var velocity = Vector2.ZERO;

export var special_fire_rate = 2;
export var radius = 10;

onready var spawner_spawnTimer:Timer = $Targeted_Spawner/Spawn_Timer;
onready var special_Timer = $SpecialTimer;
onready var animation_state = $AnimationTree.get("parameters/playback");
onready var animationTree:AnimationTree = $AnimationTree;
onready var spawner:Node2D = $Targeted_Spawner;

export var bound_add:int = 7;

func _ready():
	GlobalData.set_player_node(self)

func _input(event):
	if(event.is_action_pressed("focus")):
		$Sprite/Hitbox.show();
		spawner.is_focused = true;
		is_focused = true;
	if(event.is_action_released("focus")):
		$Sprite/Hitbox.hide();
		spawner.is_focused = false;
		is_focused = false;
	
	if(event.is_action_pressed("switch_mode")):
		if(absorb_type == 1):
			absorb_type = 0;
		else:
			absorb_type = 1;
		print(absorb_type);
	
	if(event.is_action_pressed("fire")):
		is_firing = true;
		spawner_spawnTimer.start();
	if(event.is_action_released("fire")):
		is_firing = false;
		spawner_spawnTimer.stop();
		
	if(event.is_action_pressed("special")):
		if(special_Timer.is_stopped()):
			special_Timer.start(special_fire_rate);
			print("FIRING SPECIAL!!! PEW PEW!")

func _process(delta):
	self.global_position.x = clamp(self.global_position.x, bound_add, GlobalData.get_viewport_size().x -bound_add);
	self.global_position.y = clamp(self.global_position.y, bound_add, GlobalData.get_viewport_size().y -bound_add);
	
	var input_vector = Vector2.ZERO;
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_Left");
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up");
	input_vector = input_vector.normalized();
	
	if(input_vector != Vector2.ZERO):
		animationTree.set("parameters/Move/blend_position", input_vector.x);
		animation_state.travel("Move");
		var pos = $Targeted_Spawner.position + Vector2(0, -radius);
		
		if(is_focused):
			$Spawners/Sp1.position = pos.rotated(50);
			$Spawners/Sp2.position = pos.rotated(-50);
			velocity = input_vector * focus_speed;
		else:
			$Spawners/Sp1.position = pos.rotated(20);
			$Spawners/Sp2.position = pos.rotated(-20);
			velocity = input_vector * speed;
	else:
		animation_state.travel("Idle");
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta);
	
	velocity = move_and_slide(velocity);
