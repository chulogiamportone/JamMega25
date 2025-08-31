extends Control
@onready var button: Sprite2D = $Button
var emit:bool=false
func _process(delta: float) -> void:
	if emit:
		if Input.is_action_pressed("ui_read"):
			Global.read.emit()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		button.visible=true
		emit=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name=="Player":
		button.visible=false
		emit=false
	
