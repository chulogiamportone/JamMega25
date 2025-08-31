extends Control
var scene_tree := Engine.get_main_loop() as SceneTree
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

func _on_continue_pressed() -> void:
	scene_tree.change_scene_to_file("res://main/Main.tscn")
	
func _ready():
	# Inicializa el número de caracteres visibles a 0
	label.visible_characters = 0
	# Inicia el temporizador
	timer.start()

func _on_timer_timeout():
	print("timer entro")
	# Aumenta el número de caracteres visibles en 1
	label.visible_characters += 1
	# Si no se han mostrado todos los caracteres, reinicia el temporizador
	if label.visible_characters < label.text.length():
		timer.start()
