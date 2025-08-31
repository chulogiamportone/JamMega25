extends CharacterBody2D

const SPEED := 150.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 900.0
const DASH_POWER := 10000.0
const JETPACK_FORCE := -10000.0

@export var DASH_TIME: float = 1.0
@export_range(0, 1000) var water_tank: int=1000
@onready var area_2d: Area2D = $ControlPlayer/Area2D

#@onready var anim: AnimatedSprite2D = $AnimatedSprite2D   # si usas animaciones
@onready var label: Label = $Label
@onready var control_player: Control = $ControlPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var como: Sprite2D = $ControlPlayer/Como


var can_dash := true
var dash_cooldown := 0.5
var dash_timer := 0.0
var is_dashing: bool = false
var second_jump:bool=false
var body_in_area:CharacterBody2D=null


func _physics_process(delta: float) -> void:
	label.text=str(water_tank)
	# Gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		can_dash = true   # se recupera el dash al tocar el suelo

	# Salto
	if is_on_floor():
		second_jump=false
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	else:
		if !second_jump:
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				second_jump=true

	# Jetpack con click izquierdo mantenido
	if Input.is_action_pressed("ui_jetpack"):
		water_tank-=1
		velocity.y = JETPACK_FORCE * delta

			

	# Movimiento horizontal
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x != 0:
		velocity.x = direction_x * SPEED
		control_player.scale.x=direction_x
		if direction_x>0:
			collision_shape_2d.position.x=0
		else:
			collision_shape_2d.position.x=-22
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	# Dash horizontal (W o S + tecla dash)
	if is_dashing:
		# Dash en curso
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			velocity = Vector2.ZERO  # reset para evitar arrastre
	else:
		# Movimiento normal
		if not is_on_floor():
			velocity.y += GRAVITY * delta

		velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		velocity.x *= SPEED

		# Iniciar dash
		if can_dash and Input.is_action_just_pressed("ui_dash"):
			_start_dash()

	## Ataques
	if Input.is_action_just_pressed("ui_attack"):
		animation_player.play("hoz")
		## anim.play("palo")
		if body_in_area!=null:
			body_in_area.hit_to_life-=1
			body_in_area.sprite_2d.apply_cut()
	if Input.is_action_pressed("ui_aspirar"):
		## anim.play("absorcion")
		if body_in_area!=null and body_in_area.hit_to_life<=2:
			water_tank+=500
			body_in_area.queue_free()
			body_in_area=null
	como.visible=Input.is_action_pressed("ui_aspirar")
	move_and_slide()

func _start_dash() -> void:
	water_tank-=50
	var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if dir == 0:
		dir = 1  # default a la derecha si no hay input

	velocity = Vector2(DASH_POWER * dir, 0)
	is_dashing = true
	dash_timer = DASH_TIME
	can_dash = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.get_class()=="CharacterBody2D" and body.name!="Player":
		body_in_area=body
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	body_in_area=null
