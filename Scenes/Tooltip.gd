extends Control

var label_counter = 0;
var d;

func _ready():
	d = {
		0: "Use 'Spacebar' to switch between absorb-modes.",
		1: "Shoot with 'Z'"
	};
	$CenterContainer/Label.text = d.get(label_counter);

func _input(event):
	if event.is_action("switch_mode"):
		label_counter = 1
		$CenterContainer/Label.text = d.get(label_counter);
	
	if(event.is_action_pressed("fire")):
		get_node("/root/World/ViewportContainer/Viewport/Game_View/SpawnerElement").wave_counter = 1;
		get_node("/root/World/ViewportContainer/Viewport/Game_View/SpawnerElement/SpawnerTimer").start();
		self.queue_free();
