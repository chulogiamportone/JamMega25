extends CharacterBody2D

var hit_to_life:int=5
@onready var sprite_2d: WaterEnemy2 = $Sprite2D

# Velocidad de movimiento
@export var speed: float = 800.0
# Distancia que recorre cada vez
@export var move_distance: float = 300.0
# Tiempo que espera quieto antes de moverse
@export var wait_time: float = 2.0

# Variables internas
var direction: int = 0  # -1 izquierda, 1 derecha, 0 quieto
var start_position: Vector2
var target_position: Vector2
var is_moving: bool = false
var timer: float = 0.0

func _ready() -> void:
	start_position = global_position
	_set_waiting()

func _physics_process(delta: float) -> void:
	if not is_moving:
		# Esperando
		timer -= delta
		if timer <= 0.0:
			# Decide moverse
			_set_moving()
	else:
		# Moviéndose
		var step = direction * speed * delta
		global_position.x += step
		
		# Verificamos si ya llegó al objetivo
		if (direction == 1 and global_position.x >= target_position.x) or \
		   (direction == -1 and global_position.x <= target_position.x):
			global_position.x = target_position.x
			_set_waiting()

func _set_waiting() -> void:
	is_moving = false
	direction = 0
	timer = wait_time
	start_position = global_position

func _set_moving() -> void:
	is_moving = true
	direction = -1 if randf() < 0.5 else 1
	target_position = start_position + Vector2(move_distance * direction, 0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="Player" and is_moving :
		body.water_tank-=100
