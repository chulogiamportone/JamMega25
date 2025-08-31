extends Control
var scene_tree := Engine.get_main_loop() as SceneTree

func _on_return_pressed() -> void:
	scene_tree.change_scene_to_file("res://menu/init_menu/menu.tscn")
