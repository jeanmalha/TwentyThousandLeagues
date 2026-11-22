extends Node
## All mutable game state (TTLUTS-12): flags, journal, per-character
## inventory and location, current character, language. Everything the
## player can change lives here so save/load is one dictionary.
##
## Conditions and effects are small strings so chapter data stays plain JSON:
##   conditions: "flag:x", "!flag:x", "item:x" (anyone holds it), "has:who:x",
##               "fact:x", "cat:x", "char:who", "loc:who:place", "chapter:ch01"
##   effects:    "set:x", "clear:x", "give:x" (current character), "give:who:x",
##               "take:x", "fact:x", "cat:x", "move:who:place", "goto:place",
##               "switching:on", "switching:off", "join:who", "leave:who",
##               "end_chapter"

signal changed
signal message(text: String)
signal chapter_ended

const SAVE_VERSION := 1
const CHARACTERS := ["aronnax", "conseil", "ned"]
const SPECIAL_VERB := {"aronnax": "recall", "conseil": "catalogue", "ned": "force"}

var chapter_id: String = ""
var flags: Dictionary = {}          # name -> true
var facts: Dictionary = {}          # Aronnax's recalled facts: id -> true
var catalogue: Dictionary = {}      # Conseil's catalogue entries: id -> true
var hints_shown: Dictionary = {}    # objective id -> tiers revealed (0..3)
var inventory: Dictionary = {}      # who -> Array[String]
var location: Dictionary = {}       # who -> location id
var party: Array = []               # characters present in this chapter
var current: String = "aronnax"
var switching: bool = false
var language: String = "fr"


func _ready() -> void:
	reset("")


func reset(new_chapter: String) -> void:
	chapter_id = new_chapter
	flags = {}
	facts = {}
	catalogue = {}
	hints_shown = {}
	inventory = {}
	location = {}
	for who in CHARACTERS:
		inventory[who] = []
	party = []
	current = "aronnax"
	switching = false


# --- Conditions -------------------------------------------------------------

func check(conds: Variant) -> bool:
	if conds == null:
		return true
	if conds is String:
		return _check_one(conds)
	for c in conds:
		if not _check_one(str(c)):
			return false
	return true


func _check_one(c: String) -> bool:
	if c == "" or c == "always":
		return true
	if c.begins_with("!"):
		return not _check_one(c.substr(1))
	var p := c.split(":")
	# Flag, fact and catalogue names may contain colons ("said:npc:topic").
	var rest := c.substr(c.find(":") + 1)
	match p[0]:
		"flag":
			return flags.has(rest)
		"fact":
			return facts.has(rest)
		"cat":
			return catalogue.has(rest)
		"item":
			for who in inventory:
				if p[1] in inventory[who]:
					return true
			return false
		"has":
			return p[2] in inventory.get(p[1], [])
		"char":
			return current == p[1]
		"loc":
			return location.get(p[1], "") == p[2]
		"chapter":
			return chapter_id == p[1]
	push_warning("Unknown condition: %s" % c)
	return false


# --- Effects ----------------------------------------------------------------

func apply(effects: Variant) -> void:
	if effects == null:
		return
	if effects is String:
		effects = [effects]
	var ended := false
	for e in effects:
		if _apply_one(str(e)):
			ended = true
	changed.emit()
	if ended:
		chapter_ended.emit()


## Returns true when the effect ends the chapter.
func _apply_one(e: String) -> bool:
	var p := e.split(":")
	var rest := e.substr(e.find(":") + 1)
	match p[0]:
		"set":
			flags[rest] = true
		"clear":
			flags.erase(rest)
		"fact":
			facts[rest] = true
		"cat":
			catalogue[rest] = true
		"give":
			var who: String = p[1] if p.size() > 2 else current
			var item: String = p[2] if p.size() > 2 else p[1]
			if not item in inventory[who]:
				inventory[who].append(item)
		"take":
			for who in inventory:
				inventory[who].erase(p[1])
		"move":
			location[p[1]] = p[2]
		"goto":
			location[current] = p[1]
		"switching":
			switching = p[1] == "on"
		"join":
			if not p[1] in party:
				party.append(p[1])
		"leave":
			party.erase(p[1])
			if current == p[1] and not party.is_empty():
				current = party[0]
		"end_chapter":
			return true
		_:
			push_warning("Unknown effect: %s" % e)
	return false


# --- Characters -------------------------------------------------------------

func special_verb(who: String = "") -> String:
	return SPECIAL_VERB.get(who if who != "" else current, "")


func can_switch_to(who: String) -> bool:
	return switching and who in party and who != current


func switch_to(who: String) -> bool:
	if not can_switch_to(who):
		return false
	current = who
	changed.emit()
	return true


## Hand an item to a companion standing in the same place (TTLUTS-17).
func pass_item(item: String, to: String) -> bool:
	if not item in inventory[current] or not to in party or to == current:
		return false
	if location.get(to, "") != location.get(current, ""):
		return false
	inventory[current].erase(item)
	inventory[to].append(item)
	changed.emit()
	return true


func here() -> String:
	return location.get(current, "")


# --- Save / load ------------------------------------------------------------

func to_dict() -> Dictionary:
	return {
		"version": SAVE_VERSION, "chapter": chapter_id, "flags": flags, "facts": facts,
		"catalogue": catalogue, "hints": hints_shown, "inventory": inventory,
		"location": location, "party": party, "current": current,
		"switching": switching, "language": language,
	}


func from_dict(d: Dictionary) -> void:
	# Version 1 is the first format; later versions migrate here.
	chapter_id = d.get("chapter", "")
	flags = d.get("flags", {})
	facts = d.get("facts", {})
	catalogue = d.get("catalogue", {})
	hints_shown = {}
	var hints: Dictionary = d.get("hints", {})
	for k in hints:
		hints_shown[k] = int(hints[k])   # JSON numbers load as floats
	inventory = {}
	var inv: Dictionary = d.get("inventory", {})
	for who in CHARACTERS:
		inventory[who] = Array(inv.get(who, []))
	location = d.get("location", {})
	party = Array(d.get("party", []))
	current = d.get("current", "aronnax")
	switching = d.get("switching", false)
	language = d.get("language", language)
	changed.emit()


func save_game(slot: String = "quick") -> bool:
	var f := FileAccess.open("user://save_%s.json" % slot, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(JSON.stringify(to_dict(), "\t"))
	return true


func has_save(slot: String = "quick") -> bool:
	return FileAccess.file_exists("user://save_%s.json" % slot)


func load_game(slot: String = "quick") -> bool:
	if not has_save(slot):
		return false
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string("user://save_%s.json" % slot))
	if not data is Dictionary:
		return false
	from_dict(data)
	return true
