extends Sprite2D

func _process(_delta: float) -> void:
	if $"../player".position == Vector2(900,400) or $"../player".position == Vector2(1000,400):
		visible = true
