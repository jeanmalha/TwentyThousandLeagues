class_name DialogueBox
extends Control
## Portrait dialogue (TTLUTS-15), in the manner of the first-person
## adventures it draws on: the other character's large portrait on the left,
## lines on the right, then a short list of topics. Topics appear and
## disappear with conditions (flags, recalled facts) and can run effects.

signal closed

var _id := ""
var _dlg: Dictionary = {}
var _queue: Array = []
var _pending_effects: Variant = null
# True while a line is on screen and a click should show the next one. The
# speaker label is no guide: narrator lines have no name.
var _reading := false
var _portrait: TextureRect
var _name: Label
var _speaker: Label
var _text: Label
var _topics: VBoxContainer


func _ready() -> void:
	size = Vector2(320, 180)
	mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(UiKit.rect(Color(0.02, 0.03, 0.05, 0.94), Vector2.ZERO, size))
	add_child(UiKit.rect(UiKit.PANEL, Vector2(4, 4), Vector2(98, 120)))
	_portrait = TextureRect.new()
	_portrait.position = Vector2(6, 6)
	_portrait.size = Vector2(94, 116)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_portrait)
	_name = UiKit.label("", UiKit.BRASS)
	_name.position = Vector2(6, 126)
	add_child(_name)
	_speaker = UiKit.label("", UiKit.BRASS)
	_speaker.position = Vector2(110, 6)
	add_child(_speaker)
	_text = UiKit.label("", UiKit.INK)
	_text.position = Vector2(110, 16)
	_text.size = Vector2(204, 80)
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(_text)
	_topics = VBoxContainer.new()
	_topics.position = Vector2(110, 100)
	_topics.size = Vector2(206, 76)
	_topics.add_theme_constant_override("separation", 1)
	add_child(_topics)
	hide()


func open(id: String) -> void:
	_id = id
	_dlg = Content.chapter().get("dialogues", {}).get(id, {})
	if _dlg.is_empty():
		push_warning("No dialogue %s" % id)
		closed.emit()
		return
	var npc: String = _dlg.get("npc", id)
	_portrait.texture = UiKit.portrait_texture(npc)
	_name.text = Content.character_name(npc)
	show()
	var greeting: Array = _dlg.get("greeting", [])
	if not GameState.check("flag:met:" + id) and _dlg.has("first"):
		greeting = _dlg["first"]
	GameState.flags["met:" + id] = true
	_play(greeting, null)


func _play(lines: Array, effects: Variant) -> void:
	_queue = lines.duplicate()
	_pending_effects = effects
	_clear_topics()
	_next_line()


func _next_line() -> void:
	if _queue.is_empty():
		_reading = false
		_speaker.text = ""
		if _pending_effects != null:
			GameState.apply(_pending_effects)
			_pending_effects = null
		if GameState.check("flag:end_dialogue"):
			GameState.flags.erase("end_dialogue")
			close()
			return
		_show_topics()
		return
	var line: Dictionary = _queue.pop_front()
	_reading = true
	var who: String = line.get("who", _dlg.get("npc", _id))
	if who == "me":
		who = GameState.current
	_speaker.text = Content.character_name(who)
	_text.text = Content.t(line.get("text"))


func _show_topics() -> void:
	_clear_topics()
	for topic in _dlg.get("topics", []):
		if not GameState.check(topic.get("if")):
			continue
		if topic.get("once", false) and GameState.check("flag:said:%s:%s" % [_id, topic["id"]]):
			continue
		if topic.has("who") and topic["who"] != GameState.current:
			continue
		var b := UiKit.button("› " + Content.t(topic.get("label")), Vector2.ZERO, Vector2(206, 12),
			_choose.bind(topic))
		b.custom_minimum_size = Vector2(206, 12)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_topics.add_child(b)
	var bye := UiKit.button("› " + Content.ui("goodbye"), Vector2.ZERO, Vector2(206, 12), close)
	bye.custom_minimum_size = Vector2(206, 12)
	bye.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_topics.add_child(bye)


func _choose(topic: Dictionary) -> void:
	GameState.flags["said:%s:%s" % [_id, topic["id"]]] = true
	_play(topic.get("lines", []), topic.get("do"))


func _clear_topics() -> void:
	for c in _topics.get_children():
		c.queue_free()


func close() -> void:
	_reading = false
	_clear_topics()
	hide()
	GameState.changed.emit()
	closed.emit()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if _reading:
			_next_line()


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept") and _reading:
		_next_line()
		get_viewport().set_input_as_handled()


## For tests: advance as a click would, and count the topics shown.
func advance() -> void:
	if _reading:
		_next_line()


func topic_count() -> int:
	var n := 0
	for c in _topics.get_children():
		if not c.is_queued_for_deletion():
			n += 1
	return n
