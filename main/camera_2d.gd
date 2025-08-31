extends Camera2D

var change_1:bool=true
var change_2:bool=true
var change_3:bool=true
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		if change_1:
			change_1=false
			position=Vector2(960.0+1920.0,540.0)
		else:
			change_1=true
			position=Vector2(960.0,540.0)


func _on_area_2_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		if change_2:
			change_2=false
			position=Vector2(960.0+1920.0*2,540.0)
		else:
			change_2=true
			position=Vector2(960.0,540.0)


func _on_area_3_body_entered(body: Node2D) -> void:
	if body.name=="Player":
		if change_3:
			change_3=false
			position=Vector2(960.0+1920.0*3,540.0)
		else:
			change_3=true
			position=Vector2(960.0,540.0)
