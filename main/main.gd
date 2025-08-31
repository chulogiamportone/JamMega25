extends Control

@onready var nota: Control = $Shader/Nota

func _ready() -> void:
	Global.read.connect(read_table)
	
func read_table()->void:
	nota.visible=true
