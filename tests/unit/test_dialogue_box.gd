extends GutTest
## Every dialogue must reach its topics by clicking through, including when
## the narrator (who has no name) speaks. A line with no speaker name once
## swallowed clicks and left the player stuck with no options.


func before_each() -> void:
	GameState.reset("ch04")


func test_narrator_greeting_leads_to_the_topics() -> void:
	var box := DialogueBox.new()
	add_child_autofree(box)
	box.open("strangers")
	for i in 10:
		box.advance()
	assert_gt(box.topic_count(), 1, "the strangers should offer topics, not just « take my leave »")


func test_every_dialogue_reaches_its_topics() -> void:
	for ch in Content.order:
		GameState.reset(ch)
		for id in Content.chapter(ch).get("dialogues", {}):
			var box := DialogueBox.new()
			add_child_autofree(box)
			box.open(id)
			for i in 20:
				box.advance()
			assert_gt(box.topic_count(), 0, "%s/%s: stuck before the topics" % [ch, id])
