extends GutTest
## Every chapter in data/chapters/ must be finishable, with no dead end
## anywhere (TTLUTS-14), and every line must exist in French and English.


func test_there_are_chapters() -> void:
	assert_gt(Content.order.size(), 0, "data/chapters/ should hold at least one chapter")


func test_every_chapter_is_solvable_without_dead_ends() -> void:
	for id in Content.order:
		var result: Dictionary = PuzzleSolver.new(id).run()
		assert_false(result["truncated"], "%s: state space too big to check" % id)
		assert_true(result["solvable"], "%s: the end can't be reached" % id)
		assert_eq(result["dead_ends"].size(), 0, "%s: dead ends: %s" % [id, str(result["dead_ends"].slice(0, 3))])
		gut.p("%s: %d states, solution: %s" % [id, result["states"], " → ".join(result["path"])])


func test_every_text_has_french_and_english() -> void:
	var missing: Array = []
	_scan(Content.game, "game", missing)
	for id in Content.order:
		_scan(Content.chapter(id), id, missing)
	assert_eq(missing.size(), 0, "Missing translations: %s" % str(missing.slice(0, 5)))


func test_every_chapter_starts_in_a_known_location() -> void:
	for id in Content.order:
		var ch: Dictionary = Content.chapter(id)
		for who in ch.get("start", {}).get("locations", {}):
			var loc: String = ch["start"]["locations"][who]
			assert_true(ch.get("locations", {}).has(loc), "%s: %s starts in unknown place %s" % [id, who, loc])


func test_every_exit_leads_somewhere() -> void:
	for id in Content.order:
		var ch: Dictionary = Content.chapter(id)
		for loc_id in ch.get("locations", {}):
			for e in ch["locations"][loc_id].get("exits", []):
				assert_true(ch["locations"].has(e["to"]), "%s/%s: exit to unknown %s" % [id, loc_id, e["to"]])


func test_chapters_chain_from_the_first_to_the_last() -> void:
	# Following "next" from chapter 1 must visit every chapter once, in order.
	var seen: Array = []
	var id: String = Content.order[0]
	while id != "" and not id in seen:
		seen.append(id)
		id = Content.next_chapter(id)
	assert_eq(seen, Content.order, "Chapter chain: %s" % str(seen))


func test_no_effect_list_both_opens_a_page_and_ends_the_chapter() -> void:
	# Ending the chapter starts the outro at once, so a story page opened by
	# the same effects would be cut off. Put "end_chapter" in the page itself.
	var bad: Array = []
	for id in Content.order:
		_find_page_and_end(Content.chapter(id), id, bad)
	assert_eq(bad.size(), 0, "Move end_chapter into the scene: %s" % str(bad))


func _find_page_and_end(node: Variant, path: String, bad: Array) -> void:
	if node is Dictionary:
		var effects: Variant = node.get("do")
		if effects is Array and "end_chapter" in effects:
			for e in effects:
				if str(e).begins_with("scene:"):
					bad.append(path)
		for k in node:
			_find_page_and_end(node[k], path + "/" + str(k), bad)
	elif node is Array:
		for i in node.size():
			_find_page_and_end(node[i], path + "/" + str(i), bad)


func _scan(node: Variant, path: String, missing: Array) -> void:
	if node is Dictionary:
		if node.has("fr") or node.has("en"):
			if str(node.get("fr", "")) == "" and str(node.get("en", "")) == "":
				return
			if str(node.get("fr", "")) == "" or str(node.get("en", "")) == "":
				missing.append(path)
			return
		for k in node:
			_scan(node[k], path + "/" + str(k), missing)
	elif node is Array:
		for i in node.size():
			_scan(node[i], path + "/" + str(i), missing)
