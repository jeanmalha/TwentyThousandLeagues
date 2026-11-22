class_name Narration
extends Control
## Story moments as pages of the book (TTLUTS-18, owner's playtest feedback):
## a page of paper with a running head, an engraving from the 1871 Hetzel
## edition on the left, and the text set in IM Fell on the right. Each click
## adds the next paragraph; a full page turns to a fresh one. A chapter's
## opening shows « CHAPITRE … » and its title, as in the printed book.
## Escape skips to the end; the scene's effects apply either way.

signal finished(scene_id: String)

const PAPER := Color("f0e6d0")
const PAPER_EDGE := Color("d8c9a6")
const INK := Color("3a2a1c")
const INK_SOFT := Color("7a6450")
const DESK := Color("1a0f0b")
const PAGE := Rect2(14, 4, 292, 172)
const ROMAN := ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII",
	"XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX", "XXI", "XXII", "XXIII", "XXIV"]

static var _fonts: Dictionary = {}

var _lines: Array = []
var _index := 0
var _scene_id := ""
var _effects: Variant = null
var _heading := false
var _page_no := 1
var _image: TextureRect
var _text: RichTextLabel
var _running: Label
var _folio: Label
var _turn: Label


static func book_font(style: String) -> Font:
	if not _fonts.has(style):
		var file: String = {"roman": "IMFeENrm28P", "italic": "IMFeENit28P", "sc": "IMFeENsc28P"}[style]
		var path := "res://ui/fonts/book/%s.ttf" % file
		_fonts[style] = load(path) if ResourceLoader.exists(path) else ThemeDB.fallback_font
	return _fonts[style]


func _ready() -> void:
	size = Vector2(320, 180)
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(UiKit.rect(DESK, Vector2.ZERO, size))
	add_child(UiKit.rect(Color(0, 0, 0, 0.35), PAGE.position + Vector2(2, 2), PAGE.size))
	add_child(UiKit.rect(PAPER_EDGE, PAGE.position - Vector2(1, 1), PAGE.size + Vector2(2, 2)))
	add_child(UiKit.rect(PAPER, PAGE.position, PAGE.size))
	_running = _label("", "sc", 5, INK_SOFT)
	_running.position = Vector2(PAGE.position.x, 6)
	_running.size = Vector2(PAGE.size.x, 8)
	_running.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_running)
	add_child(UiKit.rect(INK_SOFT, Vector2(PAGE.position.x + 8, 14), Vector2(PAGE.size.x - 16, 1)))
	_folio = _label("", "roman", 5, INK_SOFT)
	_folio.position = Vector2(PAGE.end.x - 24, 6)
	_folio.size = Vector2(18, 8)
	_folio.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(_folio)
	_image = TextureRect.new()
	_image.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR   # engravings are print, not pixel art
	_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_image)
	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.scroll_active = false
	_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_text.add_theme_font_override("normal_font", book_font("roman"))
	_text.add_theme_font_override("italics_font", book_font("italic"))
	_text.add_theme_font_size_override("normal_font_size", 6)
	_text.add_theme_font_size_override("italics_font_size", 6)
	_text.add_theme_color_override("default_color", INK)
	_text.add_theme_constant_override("line_separation", -1)
	add_child(_text)
	_turn = _label("❧", "roman", 8, INK_SOFT)
	_turn.position = Vector2(PAGE.end.x - 14, PAGE.end.y - 12)
	add_child(_turn)
	hide()


func _label(text: String, style: String, font_size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", book_font(style))
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


## scene: {"lines": [{"who", "text", "image"}], "do": [...], "image": "res://...", "heading": bool}
func play(scene_id: String, scene: Dictionary) -> void:
	_scene_id = scene_id
	_lines = scene.get("lines", [])
	_effects = scene.get("do")
	_heading = scene.get("heading", scene_id == "intro")
	_index = 0
	_page_no = 1
	if _lines.is_empty():
		_finish()
		return
	_running.text = Content.ui("running_head")
	_set_image(scene.get("image", ""))
	_new_page()
	show()
	_show_line()


func _set_image(path: String) -> void:
	_image.texture = load(path) if path != "" and ResourceLoader.exists(path) else null
	var has_image := _image.texture != null
	if has_image:
		_image.position = Vector2(PAGE.position.x + 8, 19)
		_image.size = Vector2(118, PAGE.size.y - 26)
		_text.position = Vector2(PAGE.position.x + 132, 19)
		_text.size = Vector2(PAGE.size.x - 140, PAGE.size.y - 30)
	else:
		_text.position = Vector2(PAGE.position.x + 18, 19)
		_text.size = Vector2(PAGE.size.x - 36, PAGE.size.y - 30)


func _new_page() -> void:
	_text.clear()
	_text.text = ""
	_folio.text = str(_page_no)
	if _heading and _page_no == 1:
		var ch: Dictionary = Content.chapter()
		var n: int = ch.get("number", 0)
		var label := Content.ui("chapter_first") if n == 1 else "%s %s" % [Content.ui("chapter"), ROMAN[n] if n < ROMAN.size() else str(n)]
		_text.append_text("[center][font_size=6][font=%s]%s[/font][/font_size]\n" % [book_font("sc").resource_path, label])
		_text.append_text("[font_size=10]%s[/font_size]\n[font_size=6]—  ✦  —[/font_size][/center]\n" % Content.t(ch.get("title")).to_upper())


func _paragraph(line: Dictionary) -> String:
	var who: String = line.get("who", "narrator")
	var body := _escape(Content.t(line.get("text")))
	if who in ["", "narrator"]:
		return "      " + body
	# Speech is set as in French books: an em dash, the words, then who said them.
	return "— %s [i](%s)[/i]" % [body, Content.character_name(who)]


func _escape(s: String) -> String:
	return s.replace("[", "[lb]")


func _show_line() -> void:
	var line: Dictionary = _lines[_index]
	if line.has("image"):
		_set_image(line["image"])
		_page_no += 1
		_new_page()
	var before := _text.text
	if _text.get_parsed_text().strip_edges() != "" and not before.ends_with("\n"):
		_text.append_text("\n")
	_text.append_text(_paragraph(line) + "\n")
	# A page that overflows turns: start a fresh one with this paragraph.
	await get_tree().process_frame
	if _text.get_content_height() > _text.size.y and _index > 0:
		_page_no += 1
		_heading = _heading and false
		_new_page()
		_text.append_text(_paragraph(line) + "\n")


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
