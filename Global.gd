extends Node
var scene_tree := Engine.get_main_loop() as SceneTree
signal read

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_quit"):
		scene_tree.quit()
		
func _ready() -> void:
	init_audio()
	
func init_audio()->void:
	var audio=AudioStream.new()
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.bus = "SFX"  # Assign to a specific audio bus
	audio_player.max_polyphony = 20  # Set the maximum number of simultaneous sounds
	# Assign an audio stream resource (e.g., a WAV file)
	var sound_stream = preload("res://music/Dungeon - Unknown Adventure.ogg")
	audio_player.stream = sound_stream
	# Add the player to the scene tree
	add_child(audio_player)
	# Play the audio
	audio_player.play()
