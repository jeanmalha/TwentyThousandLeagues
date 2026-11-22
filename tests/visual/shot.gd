extends SceneTree
## Screenshot of the game in a given state, for checking layout by eye.
##   godot --path . --resolution 960x540 -s res://tests/visual/shot.gd -- out.png [--chapter ch01 --skip-intro] [--hover x,y] [--journal] [--dialogue id] [--highlight] [--lang en] [--goto location]
## Not part of the unit tests: it opens a window.


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out := args[0] if args.size() > 0 else "user://shot.png"
	await process_frame
	var state: Node = root.get_node("/root/GameState")
	var i := args.find("--lang")
	if i >= 0:
		state.language = args[i + 1]
	var main: Node = load(ProjectSettings.get_setting("application/run/main_scene")).instantiate()
	root.add_child(main)
	for f in 20:
		await process_frame
	i = args.find("--goto")
	if i >= 0:
		state.apply(["goto:" + args[i + 1]])
		main.screen.refresh()
	if args.has("--highlight"):
		main.screen.highlight = true
		main.screen.refresh()
	i = args.find("--hover")
	if i >= 0:
		var xy := args[i + 1].split(",")
		main.screen._set_hover(main.screen._name_at(Vector2(int(xy[0]), int(xy[1]))))
	i = args.find("--say")
	if i >= 0:
		main.screen.say(state.current, args[i + 1])
	if args.has("--journal"):
		main.journal.open()
	i = args.find("--dialogue")
	if i >= 0:
		main.dialogue.open(args[i + 1])
	for f in 10:
		await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	image.save_png(out)
	print("shot: %s %dx%d" % [out, image.get_width(), image.get_height()])
	quit()
