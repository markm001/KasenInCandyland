extends KinematicBody2D

export var hp = 100;

export var velocity:Vector2 = Vector2.ZERO;
export var acceleration:float = 0.1;
export var max_speed:int = 400;

export var move_point:Vector2 = Vector2.ZERO;

onready var moveTween = $MovementTween;
onready var mechTimer = $MechanicsTimer;
export var spawn_displacement_duration = 1;
export var enemy_displacement_duration = 0.5;

export var offset_facing:float = 0.2;

enum {
	IDLE,
	MOVE
}
export var state:int = IDLE;

func _input(event):
	if Input.is_key_pressed(KEY_U):
		move_point = GlobalData.player_node.position;
		target_point(move_point);
	if Input.is_key_pressed(KEY_L):
		move_point = GlobalData.player_node.position;
		$SpawnerContainer/Barrage_Spawner.displace_spawner(move_point, spawn_displacement_duration);
	if(Input.is_key_pressed(KEY_G)):
		match state:
			IDLE:
				move_point = GlobalData.player_node.position;
				moveTween.interpolate_property(self, "global_position", global_position, move_point, enemy_displacement_duration, Tween.TRANS_EXPO);
				moveTween.start();
				state = MOVE;

func target_point(target:Vector2):
	var point_direction = (target - self.global_position).normalized()
	self.rotation = point_direction.angle() + offset_facing;

func _on_MovementTween_tween_all_completed():
	state = IDLE;


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if(area.name == "Bullet"):
		hp -= 1;
		print("Hit by bullet" + str(hp));
