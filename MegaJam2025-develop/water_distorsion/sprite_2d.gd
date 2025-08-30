extends Sprite2D

@export var absorption_speed: float = 2.0
var shader_material: ShaderMaterial

func _ready() -> void:
	shader_material = material as ShaderMaterial

func _process(delta: float) -> void:
	
	var uv_pos: Vector2 = ((texture.get_size()/2)) / texture.get_size()
	
	shader_material.set_shader_parameter("absorption_center", uv_pos)
	shader_material.set_shader_parameter("time_speed", 1.5)
	
