extends StaticBody2D

enum BrickHealth { INTACT, DAMAGED, DESTROYED }

var current_health: BrickHealth = BrickHealth.INTACT
var damage_count: int = 0

@onready var full_sprite: Sprite2D = get_node_or_null("Completo")
@onready var damaged_sprite: Sprite2D = get_node_or_null("Roto")

func _ready() -> void:
	_initialize_brick()
	add_to_group("ladrillo")

func _initialize_brick() -> void:
	if damaged_sprite:
		damaged_sprite.hide()
	if full_sprite:
		full_sprite.show()
	
	if not damaged_sprite and damage_count < 2:
		push_warning("Brick '%s': Missing 'Roto' sprite node - brick will be destroyed in one hit" % name)
	if not full_sprite:
		push_warning("Brick '%s': Missing 'Completo' sprite node" % name)

func recibir_golpe() -> void:
	damage_count += 1
	_process_damage()

func _process_damage() -> void:
	if not damaged_sprite:
		_destroy_brick()
		return
	
	match damage_count:
		1:
			_transition_to_damaged_state()
		_:
			if damage_count >= 2:
				_destroy_brick()

func _transition_to_damaged_state() -> void:
	current_health = BrickHealth.DAMAGED
	if full_sprite:
		full_sprite.hide()
	if damaged_sprite:
		damaged_sprite.show()

func _destroy_brick() -> void:
	current_health = BrickHealth.DESTROYED
	_check_win_condition()
	queue_free()

func _check_win_condition() -> void:
	var remaining_bricks: int = get_tree().get_nodes_in_group("ladrillo").size()
	if remaining_bricks == 1:
		get_tree().change_scene_to_file("res://menu_victoria.tscn")
			
			
		
