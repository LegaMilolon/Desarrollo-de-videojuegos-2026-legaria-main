extends CanvasLayer

## Lives display UI component
## Shows player lives in bottom-left corner of screen

const HEART_SPACING: float = 60.0
const BOTTOM_LEFT_POSITION: Vector2 = Vector2(40, 620)

var heart_icons: Array[Sprite2D] = []

func _ready() -> void:
	_setup_hearts_from_paddle()
	_connect_to_paddle()

func _setup_hearts_from_paddle() -> void:
	var paddle_nodes: Array = get_tree().get_nodes_in_group("paleta")
	
	if paddle_nodes.is_empty():
		push_warning("No paddle found in scene")
		return
	
	var paddle = paddle_nodes[0]
	
	# Find all heart sprites in paddle
	var heart_nodes: Array = []
	for child in paddle.get_children():
		if "Vida" in child.name and child is Sprite2D:
			heart_nodes.append(child)
	
	# Sort hearts by name to maintain order
	heart_nodes.sort_custom(func(a, b): return a.name > b.name)
	
	# Reparent hearts to this UI layer
	for i in range(heart_nodes.size()):
		var heart: Sprite2D = heart_nodes[i]
		heart.reparent(self)
		heart.position = BOTTOM_LEFT_POSITION + Vector2(i * HEART_SPACING, 0)
		heart.visible = true
		heart_icons.append(heart)

func _connect_to_paddle() -> void:
	var paddle_nodes: Array = get_tree().get_nodes_in_group("paleta")
	
	if paddle_nodes.is_empty():
		return
	
	var paddle = paddle_nodes[0]
	if paddle.has_signal("lives_changed"):
		paddle.lives_changed.connect(_on_lives_updated)

func _on_lives_updated(current_lives: int) -> void:
	_update_heart_display(current_lives)

func _update_heart_display(lives_count: int) -> void:
	for i in range(heart_icons.size()):
		heart_icons[i].visible = (i < lives_count)
