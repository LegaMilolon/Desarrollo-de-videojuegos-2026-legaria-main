extends CharacterBody2D

## Ball physics controller for Arkanoid
## Handles collision detection, bouncing, and progressive speed increase
## Implements directional bounce based on paddle hit position

const MAX_VELOCITY: float = 600.0
const BASE_SPEED: float = 300.0
const ACCELERATION_FACTOR: float = 1.05
const PADDLE_BOUNCE_ANGLE: float = 60.0  # Maximum deflection angle in degrees

var speed_multiplier: float = 1.05
var spawn_position: Vector2

func _ready() -> void:
	add_to_group("pelota")
	_configure_initial_state()

func _configure_initial_state() -> void:
	spawn_position = global_position
	velocity = Vector2.DOWN * BASE_SPEED

func _physics_process(delta: float) -> void:
	var impact: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if impact:
		_handle_collision(impact)

func _handle_collision(impact: KinematicCollision2D) -> void:
	var current_speed: float = velocity.length()
	
	if current_speed < MAX_VELOCITY:
		_apply_bounce_with_acceleration(impact)
	else:
		_reset_speed_multiplier()
		_apply_bounce_with_acceleration(impact)

func _apply_bounce_with_acceleration(impact: KinematicCollision2D) -> void:
	var hit_object = impact.get_collider()
	
	# Check if we hit the paddle for directional bounce
	if _is_paddle(hit_object):
		_apply_directional_paddle_bounce(impact, hit_object)
	else:
		# Normal bounce for walls and bricks
		var bounce_normal: Vector2 = impact.get_normal()
		velocity = velocity.bounce(bounce_normal) * speed_multiplier
	
	_notify_hit_object(hit_object)

func _is_paddle(object: Object) -> bool:
	return object.is_in_group("paleta")

func _apply_directional_paddle_bounce(impact: KinematicCollision2D, paddle: Object) -> void:
	# Calculate hit position relative to paddle center (-1 to 1)
	var ball_x: float = global_position.x
	var paddle_x: float = paddle.global_position.x
	var paddle_width: float = 230.0  # Approximate paddle width
	
	var relative_hit: float = (ball_x - paddle_x) / (paddle_width * 0.5)
	relative_hit = clamp(relative_hit, -1.0, 1.0)
	
	# Calculate bounce angle based on hit position
	var bounce_angle_deg: float = relative_hit * PADDLE_BOUNCE_ANGLE
	var bounce_angle_rad: float = deg_to_rad(bounce_angle_deg)
	
	# Get current speed and apply new direction
	var current_speed: float = velocity.length() * speed_multiplier
	
	# Create new velocity with upward direction and horizontal deflection
	var new_direction: Vector2 = Vector2(sin(bounce_angle_rad), -cos(bounce_angle_rad))
	velocity = new_direction.normalized() * current_speed

func _notify_hit_object(hit_object: Object) -> void:
	if hit_object.has_method("recibir_golpe"):
		hit_object.recibir_golpe()

func _reset_speed_multiplier() -> void:
	speed_multiplier = 1.0

func reiniciar() -> void:
	if not is_inside_tree():
		return
	
	_reposition_at_paddle()
	_reset_velocity()

func _reposition_at_paddle() -> void:
	var paddle_group: Array = get_tree().get_nodes_in_group("paleta")
	
	if paddle_group.size() > 0:
		var paddle_offset: Vector2 = Vector2(0, -50)
		global_position = paddle_group[0].global_position + paddle_offset

func _reset_velocity() -> void:
	speed_multiplier = ACCELERATION_FACTOR
	velocity = Vector2.DOWN * BASE_SPEED
	
