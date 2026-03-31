extends Control

## Game over menu controller
## Allows player to retry or return to main menu

const GAMEPLAY_SCENE: String = "res://proyecto.tscn"
const MAIN_MENU_SCENE: String = "res://menu_inicio.tscn"

func _ready() -> void:
	_setup_defeat_menu()

func _setup_defeat_menu() -> void:
	pass

func _on_reintentar_pressed() -> void:
	_restart_game()

func _on_salir_pressed() -> void:
	_return_to_main_menu()

func _restart_game() -> void:
	get_tree().change_scene_to_file(GAMEPLAY_SCENE)

func _return_to_main_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
