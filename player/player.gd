extends CharacterBody2D

const SPEED := 150.0
const JUMP_VELOCITY := -400.0
const GRAVITY := 900.0
const DASH_POWER := 500.0
const JETPACK_FORCE := -10000.0

@onready var area_2d: Area2D = $Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var anim: AnimatedSprite2D = $AnimatedSprite2D   # si usas animaciones

var can_dash := true
var dash_cooldown := 0.5
var dash_timer := 0.0
var second_jump:bool=false

var body_in_area:RigidBody2D=null
func _physics_process(delta: float) -> void:
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
		velocity.y = JETPACK_FORCE * delta
		print("jetpack")

	# Movimiento horizontal
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x != 0:
		velocity.x = direction_x * SPEED
		sprite_2d.flip_h = direction_x < 0
		area_2d.scale.x=direction_x
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	# Dash vertical (W o S + tecla dash)
	if can_dash and Input.is_action_just_pressed("ui_dash"):
		if Input.is_action_pressed("ui_left"):
			velocity.y = -DASH_POWER
			can_dash = false
		elif Input.is_action_pressed("ui_right"):
			velocity.y = DASH_POWER
			can_dash = false

	## Ataques
	if Input.is_action_just_pressed("ui_attack"):
		print("Golpe con palo")
		## anim.play("palo")
		if body_in_area!=null:
			body_in_area.hit_to_life-=1
			body_in_area.sprite_2d.apply_cut()
	if Input.is_action_pressed("ui_aspirar"):
		print("Golpe de absorción" )
		if body_in_area!=null:
			print(body_in_area.hit_to_life)
		## anim.play("absorcion")
		if body_in_area!=null and body_in_area.hit_to_life<=2:
			body_in_area.queue_free()
			body_in_area=null
		

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	body_in_area=body
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	body_in_area=null
