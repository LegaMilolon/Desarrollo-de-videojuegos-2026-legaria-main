extends CharacterBody2D

signal lives_changed(current_lives: int)

const MOVEMENT_SPEED: float = 600.0
const MAX_LIVES: int = 3

var remaining_lives: int = MAX_LIVES

func _ready() -> void:
	add_to_group("paleta")
	_setup_initial_state()

func _setup_initial_state() -> void:
	remaining_lives = MAX_LIVES
	lives_changed.emit(remaining_lives)

func _physics_process(delta: float) -> void:
	_handle_movement()
	move_and_slide()

func _handle_movement() -> void:
	var input_direction: float = Input.get_axis("ui_left", "ui_right")
	
	if input_direction != 0:
		velocity.x = input_direction * MOVEMENT_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, MOVEMENT_SPEED)

func restarVidas() -> void:
	remaining_lives -= 1
	lives_changed.emit(remaining_lives)
	
	if remaining_lives <= 0:
		_trigger_game_over()

func _trigger_game_over() -> void:
	get_tree().change_scene_to_file("res://menu_derrota.tscn")
	
		
		
	
