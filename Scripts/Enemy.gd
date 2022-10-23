extends KinematicBody2D

signal hp_depleted;

export var hp = 20;

export var velocity:Vector2 = Vector2.ZERO;
export var acceleration:float = 0.1;
export var max_speed:int = 400;

export var move_point:Vector2 = Vector2.ZERO;

onready var moveTween = $MovementTween;
onready var mechTimer = $MechanicsTimer;
onready var spawnContainer = $SpawnerContainer;
export var spawn_displacement_duration = 1;
export var enemy_displacement_duration = 0.5;

export var offset_facing:float = 0.2;
var barrage_lifetime:float = 0

var direction = Vector2(0,1);

enum {
	IDLE,
	MOVE,
	DIRECTIONAL
}
export var state:int = IDLE;

func _input(event):
	if Input.is_key_pressed(KEY_J):
		state = DIRECTIONAL;
#	if Input.is_key_pressed(KEY_U):
#		move_point = GlobalData.player_node.position;
#		target_point(move_point);
#	if Input.is_key_pressed(KEY_L):
#		move_point = GlobalData.player_node.position;
#		$SpawnerContainer/Barrage_Spawner.displace_spawner(move_point, spawn_displacement_duration);
#	if(Input.is_key_pressed(KEY_G)):
#		match state:
#			IDLE:
#				move_point = GlobalData.player_node.position;
#				moveTween.interpolate_property(self, "global_position", global_position, move_point, enemy_displacement_duration, Tween.TRANS_EXPO);
#				moveTween.start();
#				state = MOVE;

func _process(delta):
	match state:
		IDLE:
			pass
		DIRECTIONAL:
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	velocity = move_and_slide(velocity)

func target_point(target:Vector2):
	var point_direction = (target - self.global_position).normalized()
	self.rotation = point_direction.angle() + offset_facing;

func _on_MovementTween_tween_all_completed():
	state = IDLE;


func take_damage():
	hp -= 1;
	if(hp < 1):
		emit_signal("hp_depleted");

func set_active():
	if(barrage_lifetime > 0):
		mechTimer.start(barrage_lifetime);
	for spawner in spawnContainer.get_children():
		spawner.enable();
	
	state = DIRECTIONAL;

func _on_MechanicsTimer_timeout():
	for spawner in spawnContainer.get_children():
		spawner.disable();


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free();


func _on_Enemy_hp_depleted():
	state = IDLE;
	var deathSceneInstance:AnimatedSprite = GlobalData.enemyDeathEffect.instance();
	self.add_child(deathSceneInstance);
	deathSceneInstance.play("EnemyDeathEffect");
	deathSceneInstance.get_node("SuccessParticles").emitting = true;
	yield(deathSceneInstance, "animation_finished");
	self.queue_free();
