class_name Journal
extends Control
## Aronnax's journal (TTLUTS-16): objectives with three hint tiers (a nudge,
## a stronger hint, the answer), Conseil's catalogue, and recalled facts.

signal closed

var tab := "objectives"
var _body: VBoxContainer
var _tabs: Dictionary = {}


func _ready() -> void:
	size = Vector2(320, 180)
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(UiKit.rect(Color("1a0f0b"), Vector2.ZERO, size))
	add_child(UiKit.rect(Color("2b1912"), Vector2(6, 16), Vector2(308, 158)))
	var x := 6
	for t in ["objectives", "catalogue", "notes"]:
		var b := UiKit.button("", Vector2(x, 3), Vector2(70, 12), _set_tab.bind(t))
		_tabs[t] = b
		add_child(b)
		x += 72
	add_child(UiKit.button("✕", Vector2(302, 3), Vector2(12, 12), close))
	var scroll := ScrollContainer.new()
	scroll.position = Vector2(10, 19)
	scroll.size = Vector2(302, 152)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	_body = VBoxContainer.new()
	_body.custom_minimum_size = Vector2(292, 0)
	_body.add_theme_constant_override("separation", 3)
	scroll.add_child(_body)
	hide()


func open() -> void:
	show()
	refresh()


func close() -> void:
	hide()
	closed.emit()


func _set_tab(t: String) -> void:
	tab = t
	refresh()


func refresh() -> void:
	for t in _tabs:
		_tabs[t].text = Content.ui("tab_" + t)
		UiKit.set_selected(_tabs[t], t == tab)
	for c in _body.get_children():
		c.queue_free()
	match tab:
		"objectives":
			_fill_objectives()
		"catalogue":
			_fill_entries(GameState.catalogue, "catalogue", "empty_catalogue")
		"notes":
			_fill_entries(GameState.facts, "facts", "empty_notes")


func _text(s: String, color: Color = UiKit.INK) -> Label:
	var l := UiKit.label(s, color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(292, 0)
	_body.add_child(l)
	return l


func _fill_objectives() -> void:
	var ch: Dictionary = Content.chapter()
	_text(Content.t(ch.get("title")), UiKit.BRASS)
	var list: Array = Content.objectives()
	if list.is_empty():
		_text(Content.ui("no_objectives"), UiKit.DIM)
	for o in list:
		var done := Content.objective_done(o)
		_text(("✓ " if done else "• ") + Content.t(o.get("text")), UiKit.DIM if done else UiKit.INK)
		if done:
			continue
		var shown: int = GameState.hints_shown.get(o["id"], 0)
		var hints: Array = o.get("hints", [])
		for i in min(shown, hints.size()):
			_text("   " + Content.t(hints[i]), UiKit.CORAL if i == 2 else UiKit.DIM)
		if shown < hints.size():
			var b := UiKit.button(Content.ui("hint_%d" % (shown + 1)), Vector2.ZERO, Vector2(120, 11),
				_reveal_hint.bind(o["id"]))
			b.custom_minimum_size = Vector2(120, 11)
			_body.add_child(b)


func _reveal_hint(objective_id: String) -> void:
	GameState.hints_shown[objective_id] = GameState.hints_shown.get(objective_id, 0) + 1
	refresh()


func _fill_entries(owned: Dictionary, kind: String, empty_key: String) -> void:
	if owned.is_empty():
		_text(Content.ui(empty_key), UiKit.DIM)
		return
	for id in owned:
		var e: Dictionary = Content.chapter().get(kind, {}).get(id, Content.game.get(kind, {}).get(id, {}))
		_text(Content.t(e.get("name", {"fr": id, "en": id})), UiKit.BRASS)
		if e.has("text"):
			_text(Content.t(e["text"]))


func _unhandled_input(event: InputEvent) -> void:
	if visible and (event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_J)):
		close()
		get_viewport().set_input_as_handled()
