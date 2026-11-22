extends Node2D
## Start scene: owns the title screen, the play screen and the overlays
## (story cards, dialogue, journal), and moves between chapters.
##
## Command-line options for testing and screenshots (after `--`):
##   --chapter ch01      start straight into a chapter
##   --skip-intro        don't play the chapter's opening story cards

const UI_SCALE := 1

var title: TitleScreen
var screen: GameScreen
var narration: Narration
var dialogue: DialogueBox
var journal: Journal
var _after_scene: Callable = Callable()


func _ready() -> void:
	# Layout in 320×180 units. canvas_items stretch draws at window resolution,
	# so 2× art keeps its detail and text is rasterised crisp (no Control scaling).
	var root := Control.new()
	root.size = Vector2(320, 180)
	root.scale = Vector2(UI_SCALE, UI_SCALE)
	add_child(root)
	screen = GameScreen.new()
	root.add_child(screen)
	dialogue = DialogueBox.new()
	root.add_child(dialogue)
	journal = Journal.new()
	root.add_child(journal)
	narration = Narration.new()
	root.add_child(narration)
	title = TitleScreen.new()
	root.add_child(title)

	title.new_game.connect(func() -> void:
		GameState.reset("")   # a new game starts with no story flags
		start_chapter(Content.order[0] if not Content.order.is_empty() else ""))
	title.continue_game.connect(continue_game)
	title.chapter_chosen.connect(start_chapter)
	screen.open_dialogue.connect(dialogue.open)
	screen.open_journal.connect(journal.open)
	screen.play_scene.connect(play_scene)
	narration.finished.connect(_on_scene_finished)
	GameState.chapter_ended.connect(_on_chapter_ended)
	GameState.scene_requested.connect(func(id: String) -> void:
		dialogue.close()
		play_scene(id))

	var args := OS.get_cmdline_user_args()
	var i := args.find("--chapter")
	if i >= 0 and i + 1 < args.size():
		start_chapter(args[i + 1], args.has("--skip-intro"))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_F9:
				continue_game()
			KEY_F2:
				GameState.language = "en" if GameState.language == "fr" else "fr"
				GameState.changed.emit()
				title.refresh()


func start_chapter(id: String, skip_intro: bool = false) -> void:
	var ch: Dictionary = Content.chapter(id)
	if ch.is_empty():
		push_error("Unknown chapter %s" % id)
		return
	# Story flags (TTLUTS-3) carry over from the previous chapter; the rest resets.
	var carried_flags: Dictionary = {}
	var carried_facts: Dictionary = {}
	for f in Content.game.get("story_flags", []):
		if GameState.flags.has(f):
			carried_flags[f] = true
		if GameState.facts.has(f):
			carried_facts[f] = true
	GameState.reset(id)
	GameState.flags.merge(carried_flags)
	GameState.facts.merge(carried_facts)
	var start: Dictionary = ch.get("start", {})
	GameState.party = Array(start.get("party", ["aronnax"]))
	GameState.current = start.get("current", GameState.party[0])
	GameState.switching = start.get("switching", false)
	for who in start.get("locations", {}):
		GameState.location[who] = start["locations"][who]
	for who in start.get("inventory", {}):
		GameState.inventory[who] = Array(start["inventory"][who])
	GameState.apply(start.get("do"))
	title.hide()
	screen.clear_speech()
	screen.refresh()
	if not skip_intro and ch.get("scenes", {}).has("intro"):
		play_scene("intro")
	else:
		_on_scene_finished("")


func continue_game() -> void:
	var slot := "quick"
	if GameState.has_save("auto"):
		slot = "auto"
		if GameState.has_save("quick") and FileAccess.get_modified_time("user://save_quick.json") > FileAccess.get_modified_time("user://save_auto.json"):
			slot = "quick"
	if GameState.load_game(slot):
		title.hide()
		screen.clear_speech()
		screen.refresh()


func play_scene(id: String, then: Callable = Callable()) -> void:
	var scene: Dictionary = Content.chapter().get("scenes", {}).get(id, {})
	_after_scene = then
	narration.play(id, scene)


func _on_scene_finished(id: String) -> void:
	if _after_scene.is_valid():
		var cb := _after_scene
		_after_scene = Callable()
		cb.call()
		return
	screen.refresh()
	var ch: Dictionary = Content.chapter()
	if id == "intro" and ch.has("on_start_say"):
		screen.say(GameState.current, Content.t(ch["on_start_say"]))


func _on_chapter_ended() -> void:
	dialogue.hide()
	journal.hide()
	var id: String = GameState.chapter_id
	var next := Content.next_chapter(id)
	var go_next := func() -> void:
		if next == "":
			title.show()
			title.refresh()
		else:
			start_chapter(next)
	if Content.chapter().get("scenes", {}).has("outro"):
		play_scene("outro", go_next)
	else:
		go_next.call()
