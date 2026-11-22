class_name TitleScreen
extends Control
## Title screen (TTLUTS-19): new game, continue, chapter select, language.

signal new_game
signal continue_game
signal chapter_chosen(id: String)

var _buttons: Control
var _chapters: VBoxContainer
var _title: Label
var _subtitle: Label


func _ready() -> void:
	size = Vector2(320, 180)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var bg := TextureRect.new()
	bg.size = size
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	if ResourceLoader.exists("res://art/title/title.png"):
		bg.texture = load("res://art/title/title.png")
	add_child(UiKit.rect(UiKit.PANEL_DARK, Vector2.ZERO, size))
	add_child(bg)
	add_child(UiKit.rect(Color(0.02, 0.03, 0.05, 0.55), Vector2(0, 0), Vector2(320, 46)))
	_title = UiKit.label("", UiKit.BRASS, 16)
	_title.position = Vector2(0, 6)
	_title.size = Vector2(320, 20)
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_title)
	_subtitle = UiKit.label("", UiKit.DIM)
	_subtitle.position = Vector2(0, 28)
	_subtitle.size = Vector2(320, 12)
	_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_subtitle)
	_buttons = Control.new()
	add_child(_buttons)
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(60, 50)
	scroll.size = Vector2(200, 112)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	_chapters = VBoxContainer.new()
	_chapters.add_theme_constant_override("separation", 1)
	scroll.add_child(_chapters)
	scroll.hide()
	refresh()


func refresh() -> void:
	_title.text = Content.ui("game_title")
	_subtitle.text = Content.ui("game_subtitle")
	for c in _buttons.get_children():
		c.queue_free()
	var y := 104
	var entries := [["new_game", func() -> void: new_game.emit()]]
	if GameState.has_save("auto") or GameState.has_save("quick"):
		entries.append(["continue", func() -> void: continue_game.emit()])
	entries.append(["chapters", _show_chapters])
	entries.append(["language", _toggle_language])
	entries.append(["quit", func() -> void: get_tree().quit()])
	for e in entries:
		_buttons.add_child(UiKit.button(Content.ui(e[0]), Vector2(110, y), Vector2(100, 13), e[1]))
		y += 15


func _toggle_language() -> void:
	GameState.language = "en" if GameState.language == "fr" else "fr"
	refresh()


func _show_chapters() -> void:
	_buttons.hide()
	_chapters.get_parent().show()
	for c in _chapters.get_children():
		c.queue_free()
	for id in Content.order:
		var ch: Dictionary = Content.chapter(id)
		var label := "%s · %s" % [ch.get("number", ""), Content.t(ch.get("title"))]
		var b := UiKit.button(label, Vector2.ZERO, Vector2(196, 12), _pick.bind(id))
		b.custom_minimum_size = Vector2(196, 12)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_chapters.add_child(b)
	var back := UiKit.button("‹ " + Content.ui("back"), Vector2.ZERO, Vector2(196, 12), _hide_chapters)
	back.custom_minimum_size = Vector2(196, 12)
	_chapters.add_child(back)


func _hide_chapters() -> void:
	_chapters.get_parent().hide()
	_buttons.show()


func _pick(id: String) -> void:
	_hide_chapters()
	chapter_chosen.emit(id)
