extends GutTest
## Guards the pixel-art display rules from TTLUTS-1.


func test_base_resolution_is_640_by_360() -> void:
	assert_eq(ProjectSettings.get_setting("display/window/size/viewport_width"), 640)
	assert_eq(ProjectSettings.get_setting("display/window/size/viewport_height"), 360)


func test_stretch_is_canvas_items_with_integer_scaling() -> void:
	assert_eq(ProjectSettings.get_setting("display/window/stretch/mode"), "canvas_items")
	assert_eq(ProjectSettings.get_setting("display/window/stretch/scale_mode"), "integer")


func test_textures_use_nearest_neighbour_filtering() -> void:
	assert_eq(
		ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter"),
		Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	)
	assert_eq(
		get_tree().root.canvas_item_default_texture_filter,
		Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	)


func test_main_scene_loads() -> void:
	var scene: PackedScene = load(ProjectSettings.get_setting("application/run/main_scene"))
	assert_not_null(scene)
	var main := scene.instantiate()
	add_child_autofree(main)
	assert_true(main is Node2D)
