extends Node2D
## Placeholder start scene: a 320×180 test card.
## It draws 1-pixel lines and a checkerboard so you can see at a glance that
## scaling stays integer and unfiltered (no blur, no uneven pixels).

const BASE := Vector2i(320, 180)
const INK := Color(0.85, 0.75, 0.45)
const SEA := Color(0.05, 0.2, 0.3)


func _draw() -> void:
	# Frame: 1-pixel border on the outermost pixels.
	draw_rect(Rect2(Vector2(0.5, 0.5), Vector2(BASE) - Vector2.ONE), INK, false, 1.0)
	# Checkerboard of single pixels in the top-left corner.
	for y in range(4, 20):
		for x in range(4, 20):
			if (x + y) % 2 == 0:
				draw_rect(Rect2(x, y, 1, 1), INK)
	# Horizon band.
	draw_rect(Rect2(1, 120, BASE.x - 2, 59), SEA)
