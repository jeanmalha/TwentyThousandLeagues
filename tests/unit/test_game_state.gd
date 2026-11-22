extends GutTest
## Game state rules (TTLUTS-12): conditions, effects, switching, item
## passing and save/load round trips.

var _saved: Dictionary


func before_each() -> void:
	_saved = GameState.to_dict()
	GameState.reset("test")
	GameState.party = ["aronnax", "conseil", "ned"]
	for who in GameState.party:
		GameState.location[who] = "salon"


func after_each() -> void:
	GameState.from_dict(_saved)


func test_flags_and_conditions() -> void:
	assert_false(GameState.check("flag:door_open"))
	GameState.apply(["set:door_open"])
	assert_true(GameState.check("flag:door_open"))
	assert_true(GameState.check(["flag:door_open", "!flag:locked"]))
	GameState.apply("clear:door_open")
	assert_false(GameState.check("flag:door_open"))


func test_flag_names_can_contain_colons() -> void:
	GameState.apply("set:said:strangers:french")
	assert_true(GameState.check("flag:said:strangers:french"))
	assert_false(GameState.check("flag:said:strangers:english"))
	assert_false(GameState.check("flag:said"))


func test_give_take_and_item_conditions() -> void:
	GameState.apply("give:ned:harpoon")
	assert_true(GameState.check("item:harpoon"))
	assert_true(GameState.check("has:ned:harpoon"))
	assert_false(GameState.check("has:aronnax:harpoon"))
	GameState.apply("take:harpoon")
	assert_false(GameState.check("item:harpoon"))


func test_special_verbs_per_character() -> void:
	assert_eq(GameState.special_verb("aronnax"), "recall")
	assert_eq(GameState.special_verb("conseil"), "catalogue")
	assert_eq(GameState.special_verb("ned"), "force")


func test_switching_needs_permission() -> void:
	assert_false(GameState.switch_to("ned"))
	GameState.apply("switching:on")
	assert_true(GameState.switch_to("ned"))
	assert_eq(GameState.current, "ned")


func test_items_pass_only_within_the_same_place() -> void:
	GameState.apply("give:aronnax:letter")
	assert_true(GameState.pass_item("letter", "conseil"))
	assert_true(GameState.check("has:conseil:letter"))
	GameState.location["ned"] = "corridor"
	GameState.current = "conseil"
	assert_false(GameState.pass_item("letter", "ned"))


func test_save_and_load_round_trip() -> void:
	GameState.apply(["set:a", "fact:b", "cat:c", "give:ned:rope", "switching:on"])
	GameState.current = "ned"
	GameState.hints_shown["o1"] = 2
	var before := JSON.stringify(GameState.to_dict())
	assert_true(GameState.save_game("test"))
	GameState.reset("other")
	assert_true(GameState.load_game("test"))
	assert_eq(JSON.stringify(GameState.to_dict()), before)
	DirAccess.remove_absolute("user://save_test.json")
