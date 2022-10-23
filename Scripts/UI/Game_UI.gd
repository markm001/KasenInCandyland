extends Control

export(Color) var fading_color:Color = Color(.5,.5,.5,0.3);
export(Color) var active_color:Color = Color(1,1,1,1);

func _ready():
	GlobalData.connect("type_changed", self, "_on_player_skill_changed");
	

func _on_player_skill_changed(type:int):
	match type:
		0:
			$SkillContainer/Skill_Buttons/Skill_Raijuu.self_modulate = active_color;
			$SkillContainer/Skill_Buttons/Skill_Dragon.self_modulate = fading_color;
			
		1:
			$SkillContainer/Skill_Buttons/Skill_Dragon.self_modulate = active_color;
			$SkillContainer/Skill_Buttons/Skill_Raijuu.self_modulate = fading_color;
