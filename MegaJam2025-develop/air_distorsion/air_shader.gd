extends ColorRect


func _ready() -> void:
	# Asegurar que el ColorRect cubra toda la pantalla
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	

func set_wind_strength(strength: float) -> void:
	if material and material is ShaderMaterial:
		material.set_shader_parameter("wind_strength", strength)

func set_wind_direction(direction: Vector2) -> void:
	if material and material is ShaderMaterial:
		material.set_shader_parameter("wind_direction", direction)
