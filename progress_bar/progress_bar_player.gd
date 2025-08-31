extends TextureProgressBar

@onready var player: CharacterBody2D = $"../.."



func _process(delta: float) -> void:
	value=player.water_tank/10
	if value<15:
		modulate=Color(1.0, 0.212, 0.008,0.7)
	else:
		modulate=Color(1.0, 1.0, 1.0)
