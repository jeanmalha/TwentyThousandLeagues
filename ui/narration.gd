class_name Narration
extends Control
## Full-screen story cards (TTLUTS-18): an optional illustration, then lines
## of narration or speech, one per click. Escape skips to the end; the
## scene's effects apply either way, so skipping changes nothing in the game.

signal finished(scene_id: String)

var _lines: Array = []
var _index := 0
var _scene_id := ""
var _effects: Variant = null
var _image: TextureRect
var _speaker: Label
var _text: Label
var _hint: Label


func _ready() -> void:
	size = Vector2(320, 180)
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(UiKit.rect(UiKit.PANEL_DARK, Vector2.ZERO, size))
	_image = TextureRect.new()
	_image.position = Vector2(0, 0)
	_image.size = Vector2(320, 120)
	_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_image)
	_speaker = UiKit.label("", UiKit.BRASS)
	_speaker.position = Vector2(12, 124)
	add_child(_speaker)
	_text = UiKit.label("", UiKit.INK)
	_text.position = Vector2(12, 133)
	_text.size = Vector2(296, 40)
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_text)
	_hint = UiKit.label("▸", UiKit.BRASS_DARK)
	_hint.position = Vector2(310, 170)
	add_child(_hint)
	hide()


## scene: {"lines": [{"who", "text", "image"}], "do": [...], "image": "res://..."}
func play(scene_id: String, scene: Dictionary) -> void:
	_scene_id = scene_id
	_lines = scene.get("lines", [])
	_effects = scene.get("do")
	_index = 0
	_set_image(scene.get("image", ""))
	if _lines.is_empty():
		_finish()
		return
	show()
	_show_line()


func _set_image(path: String) -> void:
	_image.texture = load(path) if path != "" and ResourceLoader.exists(path) else null
	var has_image := _image.texture != null
	_speaker.position.y = 124 if has_image else 70
	_text.position.y = 133 if has_image else 79


func _show_line() -> void:
	var line: Dictionary = _lines[_index]
	if line.has("image"):
		_set_image(line["image"])
	var who: String = line.get("who", "")
	_speaker.text = "" if who in ["", "narrator"] else Content.character_name(who)
	_text.text = Content.t(line.get("text"))
	_text.add_theme_color_override("font_color", UiKit.DIM if who == "narrator" else UiKit.INK)


func advance() -> void:
	_index += 1
	if _index >= _lines.size():
		_finish()
	else:
		_show_line()


func skip() -> void:
	_finish()


func _finish() -> void:
	hide()
	GameState.apply(_effects)
	finished.emit(_scene_id)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		advance()


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_cancel"):
		skip()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		advance()
		get_viewport().set_input_as_handled()
