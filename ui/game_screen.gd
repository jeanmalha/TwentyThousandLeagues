class_name GameScreen
extends Control
## The first-person play screen (TTLUTS-11, 13, 17): a 320×144 view with
## hotspots and exits, an action line, speech, and a 36-pixel panel with the
## verbs, the current character's inventory and the three portraits.

signal open_dialogue(id: String)
signal open_journal
signal play_scene(id: String)

const VIEW := Rect2(0, 0, 320, 144)
const PANEL_Y := 144
const ITEM_SLOTS := 4

var verb: String = "look"
var held_item: String = ""
var hover_text: String = ""
var highlight := false

var _view: TextureRect
var _view_fill: ColorRect
var _overlay: Control
var _action: Label
var _action_bg: ColorRect
var _speech_bg: ColorRect
var _speech: Label
var _speaker: Label
var _verb_buttons: Dictionary = {}
var _item_buttons: Array = []
var _item_page := 0
var _portraits: Dictionary = {}
var _speech_queue: Array = []
var _speech_timer := 0.0


func _ready() -> void:
	size = Vector2(320, 180)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_view_fill = UiKit.rect(Color("0a1424"), VIEW.position, VIEW.size)
	add_child(_view_fill)
	_view = TextureRect.new()
	_view.position = VIEW.position
	_view.size = VIEW.size
	_view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_view)
	_overlay = Control.new()
	_overlay.size = VIEW.size
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.draw.connect(_draw_overlay)
	add_child(_overlay)

	_action_bg = UiKit.rect(Color(0.02, 0.03, 0.05, 0.75), Vector2(0, 0), Vector2(320, 11))
	add_child(_action_bg)
	_action = UiKit.label("", UiKit.INK)
	_action.position = Vector2(3, 0)
	_action.size = Vector2(290, 11)
	add_child(_action)
	add_child(UiKit.button("J", Vector2(297, 1), Vector2(10, 9), func() -> void: open_journal.emit()))
	add_child(UiKit.button("≡", Vector2(308, 1), Vector2(10, 9), _quick_save))

	_speech_bg = UiKit.rect(Color(0.02, 0.03, 0.05, 0.85), Vector2(0, 104), Vector2(320, 40))
	add_child(_speech_bg)
	_speaker = UiKit.label("", UiKit.BRASS)
	_speaker.position = Vector2(4, 105)
	add_child(_speaker)
	_speech = UiKit.label("", UiKit.INK)
	_speech.position = Vector2(4, 114)
	_speech.size = Vector2(312, 30)
	_speech.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_speech)

	add_child(UiKit.rect(UiKit.PANEL_DARK, Vector2(0, PANEL_Y), Vector2(320, 36)))
	add_child(UiKit.rect(UiKit.BRASS_DARK, Vector2(0, PANEL_Y), Vector2(320, 1)))
	_build_panel()
	GameState.changed.connect(refresh)
	refresh()


func _build_panel() -> void:
	var verbs := ["look", "use", "talk", "special"]
	for i in verbs.size():
		var v: String = verbs[i]
		var b := UiKit.button("", Vector2(2 + (i % 2) * 49, PANEL_Y + 3 + (i / 2) * 16), Vector2(48, 15),
			_on_verb.bind(v))
		_verb_buttons[v] = b
		add_child(b)
	for i in ITEM_SLOTS:
		var b := UiKit.button("", Vector2(102 + (i % 2) * 54, PANEL_Y + 3 + (i / 2) * 16), Vector2(53, 15),
			_on_item.bind(i))
		_item_buttons.append(b)
		add_child(b)
	add_child(UiKit.button("›", Vector2(210, PANEL_Y + 3), Vector2(8, 31), _next_item_page))
	var x := 221
	for who in GameState.CHARACTERS:
		var p := TextureButton.new()
		p.position = Vector2(x, PANEL_Y + 2)
		p.size = Vector2(31, 33)
		p.ignore_texture_size = true
		p.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_COVERED
		p.focus_mode = Control.FOCUS_NONE
		p.pressed.connect(_on_portrait.bind(who))
		p.mouse_entered.connect(func() -> void: _set_hover(Content.character_name(who)))
		p.mouse_exited.connect(func() -> void: _set_hover(""))
		_portraits[who] = p
		add_child(p)
		x += 33


# --- Refresh ----------------------------------------------------------------

func refresh() -> void:
	var loc: Dictionary = Content.location()
	var bg: String = loc.get("background", "")
	_view.texture = load(bg) if bg != "" and ResourceLoader.exists(bg) else null
	_view_fill.color = Color(loc.get("color", "#0a1424"))
	for v in _verb_buttons:
		var b: Button = _verb_buttons[v]
		var name_key: String = GameState.special_verb() if v == "special" else v
		b.text = Content.verb_name(name_key)
		b.visible = name_key != ""
		UiKit.set_selected(b, (verb == name_key) and held_item == "")
	var items: Array = GameState.inventory.get(GameState.current, [])
	var pages: int = max(1, ceili(items.size() / float(ITEM_SLOTS)))
	_item_page = clampi(_item_page, 0, pages - 1)
	for i in ITEM_SLOTS:
		var idx := _item_page * ITEM_SLOTS + i
		var b: Button = _item_buttons[i]
		b.text = Content.t(Content.item(items[idx]).get("name")) if idx < items.size() else ""
		b.disabled = idx >= items.size()
		UiKit.set_selected(b, idx < items.size() and items[idx] == held_item)
	for who in _portraits:
		var p: TextureButton = _portraits[who]
		p.visible = who in GameState.party
		p.texture_normal = UiKit.portrait_texture(who)
		p.modulate = Color.WHITE if who == GameState.current else Color(0.55, 0.6, 0.7)
		p.disabled = false
	_update_action_line()
	_overlay.queue_redraw()


func _update_action_line() -> void:
	var s: String
	if held_item != "":
		s = "%s %s %s %s" % [Content.verb_name("use"), Content.t(Content.item(held_item).get("name")),
			Content.ui("on"), hover_text]
	else:
		s = "%s %s" % [Content.verb_name(verb), hover_text]
	_action.text = s.strip_edges()
	var showing_speech := _speech.text != ""
	_speech_bg.visible = showing_speech
	_speaker.visible = showing_speech


func _set_hover(text: String) -> void:
	hover_text = text
	_update_action_line()


# --- Input ------------------------------------------------------------------

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_set_hover(_name_at(event.position))
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _speech.text != "":
			_advance_speech()
			return
		if VIEW.has_point(event.position):
			click_view(event.position)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		held_item = ""
		verb = "look"
		refresh()


func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("ui_cancel") and held_item != "":
		held_item = ""
		refresh()
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_SPACE:
				highlight = true
				_overlay.queue_redraw()
			KEY_J:
				open_journal.emit()
			KEY_F5:
				_quick_save()
			KEY_1, KEY_2, KEY_3:
				_on_portrait(GameState.CHARACTERS[event.keycode - KEY_1])
	elif event is InputEventKey and not event.pressed and event.keycode == KEY_SPACE:
		highlight = false
		_overlay.queue_redraw()


func _process(delta: float) -> void:
	if _speech_timer > 0.0:
		_speech_timer -= delta
		if _speech_timer <= 0.0:
			_advance_speech()


func _name_at(pos: Vector2) -> String:
	var h := hotspot_at(pos)
	if not h.is_empty():
		return Content.t(h.get("name"))
	var e := exit_at(pos)
	if not e.is_empty():
		return Content.t(e.get("name", {"fr": "Sortie", "en": "Exit"}))
	return ""


func hotspot_at(pos: Vector2) -> Dictionary:
	var hs: Array = Content.hotspots()
	for i in range(hs.size() - 1, -1, -1):
		if _rect(hs[i]).has_point(pos):
			return hs[i]
	return {}


func exit_at(pos: Vector2) -> Dictionary:
	for e in Content.exits():
		if _rect(e).has_point(pos):
			return e
	return {}


func _rect(d: Dictionary) -> Rect2:
	var r: Array = d.get("rect", [0, 0, 0, 0])
	return Rect2(r[0], r[1], r[2], r[3])


func click_view(pos: Vector2) -> void:
	var h := hotspot_at(pos)
	if not h.is_empty():
		act_on(h)
		return
	var e := exit_at(pos)
	if not e.is_empty():
		take_exit(e)


## Resolve the current verb (or held item) on a hotspot. Public for tests.
func act_on(h: Dictionary) -> void:
	var key := "item:" + held_item if held_item != "" else verb
	var r: Dictionary = Content.respond(h, key)
	held_item = ""
	if r.is_empty():
		if key == "talk" and h.has("dialogue"):
			open_dialogue.emit(h["dialogue"])
		else:
			say(GameState.current, Content.fallback(key, h.get("id", "")))
		verb = "look"
		refresh()
		return
	verb = "look"
	_run_response(r)


func _run_response(r: Dictionary) -> void:
	if r.has("say"):
		say(r.get("speaker", GameState.current), Content.t(r["say"]))
	if r.has("lines"):
		for line in r["lines"]:
			say(line.get("who", GameState.current), Content.t(line.get("text")))
	GameState.apply(r.get("do"))
	if r.has("dialogue"):
		open_dialogue.emit(r["dialogue"])
	if r.has("scene"):
		play_scene.emit(r["scene"])
	refresh()


func take_exit(e: Dictionary) -> void:
	if GameState.check(e.get("if")):
		GameState.apply(["goto:" + e["to"]] + Array(e.get("do", [])))
		GameState.save_game("auto")
		clear_speech()
	else:
		say(GameState.current, Content.t(e.get("locked", {"fr": "Pas encore.", "en": "Not yet."})))


# --- Panel actions ----------------------------------------------------------

func _on_verb(v: String) -> void:
	held_item = ""
	verb = GameState.special_verb() if v == "special" else v
	refresh()


func _on_item(slot: int) -> void:
	var items: Array = GameState.inventory.get(GameState.current, [])
	var idx := _item_page * ITEM_SLOTS + slot
	if idx >= items.size():
		return
	var id: String = items[idx]
	if held_item != "" and held_item != id:
		_combine(held_item, id)
		return
	if verb == "look" and held_item == "":
		say(GameState.current, Content.t(Content.item(id).get("desc", Content.item(id).get("name"))))
	else:
		held_item = "" if held_item == id else id
	refresh()


func _combine(a: String, b: String) -> void:
	held_item = ""
	for c in Content.chapter().get("combine", []):
		var pair: Array = c.get("items", [])
		if a in pair and b in pair and GameState.check(c.get("if")):
			_run_response(c)
			return
	say(GameState.current, Content.fallback("use", a + b))
	refresh()


func _next_item_page() -> void:
	_item_page += 1
	var items: Array = GameState.inventory.get(GameState.current, [])
	if _item_page * ITEM_SLOTS >= items.size():
		_item_page = 0
	refresh()


func _on_portrait(who: String) -> void:
	if not who in GameState.party:
		return
	if held_item != "" and who != GameState.current:
		var item := held_item
		held_item = ""
		if GameState.pass_item(item, who):
			say(who, Content.ui("thanks"))
		else:
			say(GameState.current, Content.ui("not_here"))
		refresh()
		return
	if who == GameState.current:
		return
	if GameState.switch_to(who):
		clear_speech()
		_item_page = 0
	else:
		say(GameState.current, Content.ui("no_switch"))
	refresh()


func _quick_save() -> void:
	if GameState.save_game("quick"):
		say("", Content.ui("saved"))


# --- Speech -----------------------------------------------------------------

## Queue a line of speech. who = "" for system messages.
func say(who: String, text: String) -> void:
	if text == "":
		return
	_speech_queue.append([who, text])
	if _speech.text == "":
		_advance_speech()


func _advance_speech() -> void:
	if _speech_queue.is_empty():
		clear_speech()
		return
	var line: Array = _speech_queue.pop_front()
	_speaker.text = Content.character_name(line[0]) if line[0] != "" else ""
	_speech.text = line[1]
	_speech_timer = 2.0 + line[1].length() * 0.06
	_update_action_line()


func clear_speech() -> void:
	_speech_queue.clear()
	_speech.text = ""
	_speaker.text = ""
	_speech_timer = 0.0
	_update_action_line()


func is_speaking() -> bool:
	return _speech.text != ""


# --- Drawing ----------------------------------------------------------------

func _draw_overlay() -> void:
	# People in the scene (hotspots with "npc") appear as framed portrait
	# medallions where they stand, until full in-scene figures exist (TTLUTS-32).
	for h in Content.hotspots():
		if h.has("npc"):
			var r := _rect(h)
			var frame := Rect2(r.position.x + r.size.x / 2 - 15, r.position.y + 2, 30, 37)
			_overlay.draw_rect(frame.grow(1), UiKit.PANEL_DARK)
			_overlay.draw_rect(frame, UiKit.BRASS_DARK)
			_overlay.draw_texture_rect(UiKit.portrait_texture(h["npc"]), frame.grow(-1), false)
			_overlay.draw_rect(frame, UiKit.BRASS, false, 1.0)
	if _view.texture == null:
		# No art yet: draw the hotspots as labelled boxes so the scene stays playable.
		for h in Content.hotspots():
			var r := _rect(h)
			_overlay.draw_rect(r, Color(0.06, 0.13, 0.21, 0.9))
			_overlay.draw_rect(r, UiKit.BRASS_DARK, false, 1.0)
			_overlay.draw_string(UiKit.get_font(), r.position + Vector2(2, 9), Content.t(h.get("name")),
				HORIZONTAL_ALIGNMENT_LEFT, r.size.x - 3, UiKit.FONT_SIZE, UiKit.DIM)
		for e in Content.exits():
			var r := _rect(e)
			_overlay.draw_rect(r, Color(0.18, 0.45, 0.46, 0.35))
			_overlay.draw_string(UiKit.get_font(), r.position + Vector2(2, 9), "»",
				HORIZONTAL_ALIGNMENT_LEFT, -1, UiKit.FONT_SIZE, UiKit.INK)
	if not highlight:
		return
	for h in Content.hotspots():
		_overlay.draw_rect(_rect(h), UiKit.BRASS, false, 1.0)
	for e in Content.exits():
		_overlay.draw_rect(_rect(e), UiKit.SEA, false, 1.0)
