extends Node
## Game content loaded from JSON (TTLUTS-14): characters, items, generic
## per-character lines, and one file per chapter in data/chapters/.
## Every piece of player-facing text is {"fr": "...", "en": "..."}.

const GAME_FILE := "res://data/game.json"
const CHAPTER_DIR := "res://data/chapters/"

var game: Dictionary = {}
var chapters: Dictionary = {}   # id -> chapter dictionary
var order: Array = []           # chapter ids in play order


func _ready() -> void:
	load_all()


func load_all() -> void:
	game = _read_json(GAME_FILE)
	chapters = {}
	order = []
	var dir := DirAccess.open(CHAPTER_DIR)
	if dir == null:
		return
	var files: Array = []
	for f in dir.get_files():
		if f.ends_with(".json"):
			files.append(f)
	files.sort()
	for f in files:
		var ch: Dictionary = _read_json(CHAPTER_DIR + f)
		if ch.has("id"):
			chapters[ch["id"]] = ch
			order.append(ch["id"])


func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Missing data file: %s" % path)
		return {}
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not parsed is Dictionary:
		push_error("Invalid JSON in %s" % path)
		return {}
	return parsed


# --- Text -------------------------------------------------------------------

## Pick the current language from a {"fr", "en"} pair, falling back to the other.
func t(text: Variant) -> String:
	if text == null:
		return ""
	if text is String:
		return text
	var lang: String = GameState.language
	var s: String = text[lang] if text.has(lang) and str(text[lang]) != "" else text.get("fr", text.get("en", ""))
	# Titles are marked *like this* in the data; plain labels show them as is.
	return s.replace("*", "")


func ui(key: String) -> String:
	return t(game.get("ui", {}).get(key, key))


func character_name(who: String) -> String:
	var c: Dictionary = game.get("characters", {}).get(who, {})
	return t(c.get("name", who.capitalize()))


func verb_name(verb: String) -> String:
	return t(game.get("verbs", {}).get(verb, verb.capitalize()))


func item(id: String) -> Dictionary:
	var ch: Dictionary = chapter()
	if ch.get("items", {}).has(id):
		return ch["items"][id]
	return game.get("items", {}).get(id, {"name": {"fr": id, "en": id}})


# --- Chapters and locations -------------------------------------------------

func chapter(id: String = "") -> Dictionary:
	return chapters.get(id if id != "" else GameState.chapter_id, {})


func location(loc_id: String = "") -> Dictionary:
	return chapter().get("locations", {}).get(loc_id if loc_id != "" else GameState.here(), {})


func next_chapter(id: String) -> String:
	var ch: Dictionary = chapter(id)
	if ch.has("next"):
		return ch["next"]
	var i := order.find(id)
	return order[i + 1] if i >= 0 and i + 1 < order.size() else ""


## Visible hotspots in a location for the current state.
func hotspots(loc_id: String = "") -> Array:
	var out: Array = []
	for h in location(loc_id).get("hotspots", []):
		if GameState.check(h.get("if")):
			out.append(h)
	return out


func exits(loc_id: String = "") -> Array:
	var out: Array = []
	for e in location(loc_id).get("exits", []):
		if GameState.check(e.get("visible_if")):
			out.append(e)
	return out


# --- Interactions (TTLUTS-13) ----------------------------------------------

## Find the response to `verb_key` on hotspot `h` for the current character.
## verb_key is a verb ("look", "use", "talk", "recall", "catalogue", "force")
## or "item:<id>" for using an inventory item on the hotspot.
## Returns {"say": text, "do": effects, "dialogue": id, "scene": id} or {} if none.
func respond(h: Dictionary, verb_key: String) -> Dictionary:
	var who: String = GameState.current
	for r in h.get("actions", {}).get(verb_key, []):
		var for_who: Variant = r.get("who", "*")
		if for_who is String and for_who != "*" and for_who != who:
			continue
		if for_who is Array and not who in for_who:
			continue
		if GameState.check(r.get("if")):
			return r
	return {}


## The line to show when nothing specific matches: generic per character
## and verb, chosen deterministically from the hotspot id so it doesn't flicker.
func fallback(verb_key: String, target_id: String) -> String:
	var who: String = GameState.current
	var verb: String = "use" if verb_key.begins_with("item:") else verb_key
	var lines: Array = game.get("fallbacks", {}).get(who, {}).get(verb, [])
	if lines.is_empty():
		lines = game.get("fallbacks", {}).get("*", {}).get(verb, [])
	if lines.is_empty():
		return "…"
	return t(lines[abs(target_id.hash()) % lines.size()])


# --- Objectives (TTLUTS-16) -------------------------------------------------

func objectives() -> Array:
	var out: Array = []
	for o in chapter().get("objectives", []):
		if GameState.check(o.get("show_if")):
			out.append(o)
	return out


func objective_done(o: Dictionary) -> bool:
	return GameState.check(o.get("done_if", ["flag:__never__"]))
