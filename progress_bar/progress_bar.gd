extends TextureProgressBar
@onready var player: CharacterBody2D = $"../../Player"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
var scene_tree := Engine.get_main_loop() as SceneTree

func _process(delta: float) -> void:
	value=player.water_tank/10
	if value<15:
		modulate=Color(1.0, 0.0, 0.0, 0.827)
		animation_player.play("shader_tank")
	else:
		modulate=Color(1.0, 1.0, 1.0)
		animation_player.play("RESET")
	if value==0:
		dead()
		
func dead()->void:
	scene_tree.change_scene_to_file("res://menu/dead/dead.tscn")
	
