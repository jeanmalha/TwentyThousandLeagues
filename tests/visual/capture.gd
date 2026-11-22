extends SceneTree
## Renders the main scene in a real window and saves a screenshot, to check
## that pixels stay crisp at a given window size. Not part of the unit tests.
##   godot --path . --resolution 1280x720 -s res://tests/visual/capture.gd -- out.png
## An optional second argument sizes a borderless window at the top-left
## corner, for sizes as large as the screen (e.g. ×6 on a 1080p display):
##   godot --path . -s res://tests/visual/capture.gd -- out.png 1920x1080

const STABLE_FRAMES := 10
const MAX_FRAMES := 300


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out := args[0] if args.size() > 0 else "user://capture.png"
	var main: Node = load(ProjectSettings.get_setting("application/run/main_scene")).instantiate()
	root.add_child(main)
	if args.size() > 1:
		var wh := args[1].split("x")
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		DisplayServer.window_set_position(DisplayServer.screen_get_position())
		DisplayServer.window_set_size(Vector2i(int(wh[0]), int(wh[1])))
	# Wait for the window to settle (fullscreen switches take a few frames).
	var last := Vector2i.ZERO
	var stable := 0
	for i in MAX_FRAMES:
		await process_frame
		var size := DisplayServer.window_get_size()
		stable = stable + 1 if size == last else 0
		last = size
		if stable >= STABLE_FRAMES and i > 30:
			break
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var err := image.save_png(out)
	print("capture: %s window %s image %dx%d err=%d" % [
		out, DisplayServer.window_get_size(), image.get_width(), image.get_height(), err])
	quit(err)
