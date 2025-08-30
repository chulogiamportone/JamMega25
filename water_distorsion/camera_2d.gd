extends Camera2D
@onready var player: CharacterBody2D = $"../Player"

#@export var follow_speed: float = 2.0
#
#func _process(delta: float) -> void:
	#if player:
		## Interpolación suave de la posición de la cámara
		#global_position = global_position.lerp(player.position, follow_speed * delta)
