extends Area2D

var bullet_type:int;

var velocity:int = 200;
var acceleration:float = 0;
var lifetime:float = 5.0;
var direction:Vector2 = Vector2();
var add_rotation:bool = false;
var rotation_change:int = 40;
var rotation_speed:float = 0;
var orbital_velocity:float = 0;

var timer:float = 0;

var use_special:bool = false;
var change_direction:bool = false;
var special_direction:Vector2 = Vector2();
var trigger_time:float = 0;

func _process(delta):
	timer += delta
	if(timer > lifetime):
		delete();
	
	if(use_special):
		if(timer > trigger_time):
			change_direction = true;
			
			position += special_direction * velocity * delta;
	
	if(change_direction == false):
		if(add_rotation):
			var dir:Vector2 = Vector2(cos(rotation), sin(rotation));
			position += dir * velocity * delta;
		else:
			position += direction.normalized() * velocity * delta;
		
		direction = direction.rotated(orbital_velocity);
		rotation_degrees += rotation_speed * delta;
	
	
	velocity += acceleration;
	rotation_degrees += rotation_change * delta;


func set_properties(type:int, vel:int, accel:float, l_time:float, add_rot:bool, rot_change:int, rot_speed:float, orbit_vel:float):
	self.bullet_type = type;
	self.velocity = vel;
	self.acceleration = accel;
	self.lifetime = l_time;
	self.add_rotation = add_rot;
	self.rotation_change = rot_change;
	self.rotation_speed = rot_speed;
	self.orbital_velocity = orbit_vel;


func append_special(s_direction:Vector2, s_time:float):
	self.use_special = true;
	self.special_direction = s_direction;
	self.trigger_time = s_time;


func delete():
	GlobalData.bullet_array.erase(self);
	self.queue_free();


func set_Sprite(sprite:Sprite):
	$BulletSprite.texture = sprite;

func _on_Bullet_body_entered(body):
	if(body.name == "Player"):
		if(bullet_type == body.absorb_type):
			GlobalData.increase_gauge(bullet_type);
		else:
			GlobalData.reduce_gauge(bullet_type);
