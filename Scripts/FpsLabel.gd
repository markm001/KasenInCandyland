extends Label

func _ready():
	self.visible = GlobalData.show_fps;

func _process(_delta):
	set_text("FPS: " + str(Engine.get_frames_per_second()) + "\n" + "B:" + str(GlobalData.bullet_array.size()))
