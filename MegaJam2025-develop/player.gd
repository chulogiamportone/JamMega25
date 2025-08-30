extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta*6

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		if Input.is_action_pressed("ui_left"):
			sprite_2d.flip_h = true
			#animated_sprite_3d.play("side")
		if Input.is_action_pressed("ui_right"):
			sprite_2d.flip_h = false
			#animated_sprite_3d.play("side")
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction_y := Input.get_axis("ui_up","ui_down")
	if direction_y:
		#if Input.is_action_pressed("ui_up"):
			#animated_sprite_3d.play("side")
		#if Input.is_action_pressed("ui_down"):
			#animated_sprite_3d.play("side")
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	#if Input.is_action_pressed("ui_easy_attack"):
			#animated_sprite_3d.play("easy_attack")
	#if Input.is_action_pressed("ui_heavy_attack"):
			#animated_sprite_3d.play("hard_attack")
	#if Input.is_action_pressed("ui_ultimate_atttack"):
		#animated_sprite_3d.play("ultimate_attack")
	#if Input.is_action_pressed("ui_slide"):
			#animated_sprite_3d.play("slide")
	move_and_slide()
