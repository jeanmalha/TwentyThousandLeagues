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
	# The 1871 Hetzel frontispiece on the left, like the book's first page;
	# title and menu on the right.
	add_child(UiKit.rect(Color("1a0f0b"), Vector2.ZERO, size))
	add_child(UiKit.rect(Color("d8c9a6"), Vector2(13, 3), Vector2(134, 174)))
	var bg := TextureRect.new()
	bg.position = Vector2(14, 4)
	bg.size = Vector2(132, 172)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	if ResourceLoader.exists("res://art/engravings/hetzel-003.jpg"):
		bg.texture = load("res://art/engravings/hetzel-003.jpg")
	add_child(bg)
	_title = Label.new()
	_title.add_theme_font_override("font", Narration.book_font("sc"))
	_title.add_theme_font_size_override("font_size", 14)
	_title.add_theme_color_override("font_color", Color("e2ae4f"))
	_title.position = Vector2(160, 18)
	_title.size = Vector2(150, 40)
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_title)
	_subtitle = Label.new()
	_subtitle.add_theme_font_override("font", Narration.book_font("italic"))
	_subtitle.add_theme_font_size_override("font_size", 8)
	_subtitle.add_theme_color_override("font_color", Color("cfcbbf"))
	_subtitle.position = Vector2(160, 62)
	_subtitle.size = Vector2(150, 12)
	_subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_subtitle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_subtitle)
	_buttons = Control.new()
	add_child(_buttons)
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(156, 78)
	scroll.size = Vector2(158, 98)
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
	var y := 86
	var entries := [["new_game", func() -> void: new_game.emit()]]
	if GameState.has_save("auto") or GameState.has_save("quick"):
		entries.append(["continue", func() -> void: continue_game.emit()])
	entries.append(["chapters", _show_chapters])
	entries.append(["language", _toggle_language])
	entries.append(["quit", func() -> void: get_tree().quit()])
	for e in entries:
		_buttons.add_child(UiKit.button(Content.ui(e[0]), Vector2(185, y), Vector2(100, 13), e[1]))
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
		var b := UiKit.button(label, Vector2.ZERO, Vector2(154, 12), _pick.bind(id))
		b.custom_minimum_size = Vector2(154, 12)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_chapters.add_child(b)
	var back := UiKit.button("‹ " + Content.ui("back"), Vector2.ZERO, Vector2(154, 12), _hide_chapters)
	back.custom_minimum_size = Vector2(154, 12)
	_chapters.add_child(back)


func _hide_chapters() -> void:
	_chapters.get_parent().hide()
	_buttons.show()


func _pick(id: String) -> void:
	_hide_chapters()
	chapter_chosen.emit(id)
