class_name PuzzleSolver
extends RefCounted
## Proves the "no dead ends" pillar for a chapter (TTLUTS-14). It explores
## every state the chapter's data can reach (flags, items, places, current
## character) by trying every action a player could take, then checks that:
##   1. the end of the chapter is reachable from the start, and
##   2. from every reachable state the end is still reachable (no dead end).
## It drives the real GameState and Content, so it tests the same rules the
## game runs.

const MAX_STATES := 20000

var chapter_id: String
var states: Dictionary = {}     # key -> state dict
var edges: Dictionary = {}      # key -> Array of [next_key, label]
var wins: Dictionary = {}       # keys from which one action ends the chapter
var truncated := false


var relevant: Dictionary = {}   # "flag:x" / "fact:x" / "cat:x" that some condition tests


func _init(id: String) -> void:
	chapter_id = id
	_collect_relevant(Content.chapter(id))


## Only flags, facts and catalogue entries that some condition reads can
## change what the player can do; the rest (flavour, "already said") are left
## out of the state key so the search stays small.
func _collect_relevant(node: Variant) -> void:
	if node is Dictionary:
		for k in node:
			if k in ["if", "visible_if"]:
				var conds: Variant = node[k]
				for c in (conds if conds is Array else [conds]):
					var s := str(c).trim_prefix("!")
					relevant[s] = true
			else:
				_collect_relevant(node[k])
	elif node is Array:
		for v in node:
			_collect_relevant(v)


## Returns {"solvable": bool, "dead_ends": Array of labels, "states": int,
##          "path": Array of action labels to the end, "truncated": bool}
func run() -> Dictionary:
	var saved: Dictionary = GameState.to_dict()
	var start: Dictionary = _start_state()
	var start_key := _key(start)
	states[start_key] = start
	var queue: Array = [start_key]
	var parent: Dictionary = {start_key: null}
	var win_path: Array = []
	while not queue.is_empty():
		var k: String = queue.pop_front()
		edges[k] = []
		for move in _moves(states[k]):
			if move["ends"]:
				wins[k] = move["label"]
				if win_path.is_empty():
					win_path = _path(parent, k) + [move["label"]]
				continue
			var nk := _key(move["state"])
			edges[k].append([nk, move["label"]])
			if not states.has(nk):
				if states.size() >= MAX_STATES:
					truncated = true
					continue
				states[nk] = move["state"]
				parent[nk] = [k, move["label"]]
				queue.append(nk)
	GameState.from_dict(saved)
	# States that can still reach the end: walk the graph backwards from wins.
	var good: Dictionary = {}
	for k in wins:
		good[k] = true
	var grew := true
	while grew:
		grew = false
		for k in edges:
			if good.has(k):
				continue
			for e in edges[k]:
				if good.has(e[0]):
					good[k] = true
					grew = true
					break
	var dead: Array = []
	for k in states:
		if not good.has(k):
			dead.append(" → ".join(_path(parent, k)))
	return {"solvable": good.has(start_key), "dead_ends": dead, "states": states.size(),
		"path": win_path, "truncated": truncated}


func _start_state() -> Dictionary:
	var ch: Dictionary = Content.chapter(chapter_id)
	GameState.reset(chapter_id)
	var start: Dictionary = ch.get("start", {})
	GameState.party = Array(start.get("party", ["aronnax"]))
	GameState.current = start.get("current", GameState.party[0])
	GameState.switching = start.get("switching", false)
	for who in start.get("locations", {}):
		GameState.location[who] = start["locations"][who]
	for who in start.get("inventory", {}):
		GameState.inventory[who] = Array(start["inventory"][who])
	GameState.apply(start.get("do"))
	var intro: Dictionary = ch.get("scenes", {}).get("intro", {})
	GameState.apply(intro.get("do"))
	return GameState.to_dict()


func _key(s: Dictionary) -> String:
	var parts: Array = []
	var prefix := {"flags": "flag:", "facts": "fact:", "catalogue": "cat:"}
	for field in ["flags", "facts", "catalogue"]:
		var keys: Array = []
		for k in s[field]:
			if relevant.has(prefix[field] + str(k)):
				keys.append(k)
		keys.sort()
		parts.append(",".join(keys))
	for who in GameState.CHARACTERS:
		var inv: Array = s["inventory"].get(who, []).duplicate()
		inv.sort()
		parts.append(who + "=" + ",".join(inv) + "@" + str(s["location"].get(who, "")))
	var party: Array = s["party"].duplicate()
	party.sort()
	# With free switching, who is active doesn't change what can be done.
	var current: String = "*" if s["switching"] else s["current"]
	parts.append(",".join(party) + "|" + current + "|" + str(s["switching"]))
	return ";".join(parts)


## Try `effects` from state `s`: returns [new_state, ends_chapter].
func _try(s: Dictionary, effects: Array) -> Array:
	GameState.from_dict(s.duplicate(true))
	# A "scene:id" effect plays a story page whose own effects then apply.
	var expanded: Array = []
	for e in effects:
		expanded.append(e)
		if str(e).begins_with("scene:"):
			expanded += Array(Content.chapter(chapter_id).get("scenes", {}).get(str(e).substr(6), {}).get("do", []))
	effects = expanded
	var ends := false
	for e in effects:
		if str(e) == "end_chapter":
			ends = true
	GameState.apply(effects)
	return [GameState.to_dict(), ends]


func _moves(s: Dictionary) -> Array:
	var out: Array = []
	var ch: Dictionary = Content.chapter(chapter_id)
	var actors: Array = s["party"] if s["switching"] else [s["current"]]
	for who in actors:
		var base: Dictionary = s.duplicate(true)
		base["current"] = who
		GameState.from_dict(base.duplicate(true))
		var loc: String = s["location"].get(who, "")
		var location: Dictionary = ch.get("locations", {}).get(loc, {})
		var candidates: Array = []   # [label, effects]
		for h in location.get("hotspots", []):
			GameState.from_dict(base.duplicate(true))
			if not GameState.check(h.get("if")):
				continue
			for verb_key in h.get("actions", {}):
				if verb_key.begins_with("item:") and not verb_key.substr(5) in s["inventory"].get(who, []):
					continue
				GameState.from_dict(base.duplicate(true))
				var r: Dictionary = Content.respond(h, verb_key)
				if r.is_empty():
					continue
				var eff: Array = Array(r.get("do", []))
				if r.has("scene"):
					eff += Array(ch.get("scenes", {}).get(r["scene"], {}).get("do", []))
				candidates.append(["%s:%s %s" % [who, verb_key, h["id"]], eff, r.get("dialogue", "")])
			if h.has("dialogue"):
				candidates.append(["%s:talk %s" % [who, h["id"]], [], h["dialogue"]])
		for e in location.get("exits", []):
			GameState.from_dict(base.duplicate(true))
			if GameState.check(e.get("visible_if")) and GameState.check(e.get("if")):
				candidates.append(["%s:exit %s" % [who, e["id"]], ["goto:" + e["to"]] + Array(e.get("do", [])), ""])
		for c in ch.get("combine", []):
			var pair: Array = c.get("items", [])
			if pair.size() == 2 and pair[0] in s["inventory"].get(who, []) and pair[1] in s["inventory"].get(who, []):
				GameState.from_dict(base.duplicate(true))
				if GameState.check(c.get("if")):
					candidates.append(["%s:combine %s" % [who, "+".join(pair)], Array(c.get("do", [])), ""])
		for c in candidates:
			if c[1].size() > 0 or c[2] == "":
				var res := _try(base, c[1])
				out.append({"label": c[0], "state": res[0], "ends": res[1]})
			if c[2] != "":
				out += _dialogue_moves(base, c[0], c[2])
	return out


func _dialogue_moves(base: Dictionary, label: String, dlg_id: String) -> Array:
	var out: Array = []
	var dlg: Dictionary = Content.chapter(chapter_id).get("dialogues", {}).get(dlg_id, {})
	var opened: Dictionary = base.duplicate(true)
	opened["flags"]["met:" + dlg_id] = true
	for topic in dlg.get("topics", []):
		GameState.from_dict(opened.duplicate(true))
		if not GameState.check(topic.get("if")):
			continue
		if topic.has("who") and topic["who"] != opened["current"]:
			continue
		var said := "said:%s:%s" % [dlg_id, topic["id"]]
		if topic.get("once", false) and opened["flags"].has(said):
			continue
		var res := _try(opened, ["set:" + said] + Array(topic.get("do", [])))
		out.append({"label": "%s/%s" % [label, topic["id"]], "state": res[0], "ends": res[1]})
	return out


func _path(parent: Dictionary, k: String) -> Array:
	var labels: Array = []
	var cur: Variant = parent.get(k)
	while cur != null:
		labels.push_front(cur[1])
		cur = parent.get(cur[0])
	return labels
