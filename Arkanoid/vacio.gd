extends Area2D

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	body_entered.connect(_on_ball_fallen)

func _on_ball_fallen(fallen_body: Node2D) -> void:
	if not _is_ball(fallen_body):
		return
	
	_process_life_loss()
	_respawn_ball(fallen_body)

func _is_ball(body: Node2D) -> bool:
	return body.is_in_group("pelota")

func _process_life_loss() -> void:
	var paddle_nodes: Array = get_tree().get_nodes_in_group("paleta")
	
	if paddle_nodes.is_empty():
		return
	
	var active_paddle = paddle_nodes[0]
	active_paddle.restarVidas()

func _respawn_ball(ball: Node2D) -> void:
	ball.reiniciar()
