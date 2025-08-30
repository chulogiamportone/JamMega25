extends Sprite2D
class_name WaterEnemy

## Configuración del corte
@export var reconstruct_delay: float = 2.0
@export var separation_distance: float = 0.05

var shader_material: ShaderMaterial
var is_cut: bool = false
var timer: Timer




func _ready() -> void:
	# Crear el material con shader
	shader_material = material as ShaderMaterial
	
	# Configurar timer
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_reconstruct)
	
	print("WaterEnemy listo para ser cortado!")



## Función principal para aplicar el corte
func apply_cut() -> void:
	if is_cut:
		print("Ya está cortado, esperá a que se reconstruya!")
		return
		
	print("¡CORTE APLICADO! 🗡️")
	is_cut = true
	shader_material.set_shader_parameter("is_cut", true)
	shader_material.set_shader_parameter("cut_progress", 0.0)
	timer.start(reconstruct_delay)

func _on_reconstruct() -> void:
	print("Reconstruyendo enemigo de agua... 💧")
	
	# Animación suave de reconstrucción
	var tween: Tween = create_tween()
	tween.tween_method(
		func(progress: float): shader_material.set_shader_parameter("cut_progress", progress),
		0.0, 1.0, 0.8
	)
	
	tween.finished.connect(func():
		is_cut = false
		shader_material.set_shader_parameter("is_cut", false)
		shader_material.set_shader_parameter("cut_progress", 0.0)
		print("¡Enemigo reconstruido! ✨")
	)


func _on_button_pressed() -> void:
	apply_cut()
