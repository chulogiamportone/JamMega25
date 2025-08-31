extends Control
var scene_tree := Engine.get_main_loop() as SceneTree

func _on_start_pressed() -> void:
	scene_tree.change_scene_to_file("res://main/Main.tscn")

func _on_credit_pressed() -> void:
	scene_tree.change_scene_to_file("res://menu/credits/credits.tscn")


func _on_quit_pressed() -> void:
	scene_tree.quit()
