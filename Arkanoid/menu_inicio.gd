extends Control

const GAME_SCENE_PATH: String = "res://proyecto.tscn"

func _ready() -> void:
	_initialize_menu()

func _initialize_menu() -> void:
	pass

func _on_jugar_pressed() -> void:
	_start_game()

func _on_salir_pressed() -> void:
	_quit_application()

func _start_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE_PATH)

func _quit_application() -> void:
	get_tree().quit()
