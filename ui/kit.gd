class_name UiKit
extends RefCounted
## Small helpers to build the 320×180 interface in code, using colours from
## the master palette (art/palette/master-64.gpl).

const INK := Color("f4efe0")        # Neutral 8
const DIM := Color("a9a9a2")        # Neutral 6
const BRASS := Color("e2ae4f")      # Brass 7
const BRASS_DARK := Color("86531a") # Brass 4
const PANEL := Color("0f2236")      # Abyss 3
const PANEL_DARK := Color("05080c") # Abyss 1
const SEA := Color("2e7476")        # Sea 5
const CORAL := Color("e8936a")      # Coral 7
const FONT_SIZE := 8

static var font: Font


static func get_font() -> Font:
	if font == null:
		var path := "res://ui/fonts/pixel.ttf"
		if ResourceLoader.exists(path):
			font = load(path)
		else:
			var f := FontVariation.new()
			f.base_font = ThemeDB.fallback_font
			font = f
	return font


static func label(text: String, color: Color = INK, size: int = FONT_SIZE) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", get_font())
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_constant_override("line_spacing", 0)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


static func rect(color: Color, pos: Vector2, size: Vector2) -> ColorRect:
	var r := ColorRect.new()
	r.color = color
	r.position = pos
	r.size = size
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


static func button(text: String, pos: Vector2, size: Vector2, on_press: Callable) -> Button:
	var b := Button.new()
	b.focus_mode = Control.FOCUS_NONE
	b.clip_text = true
	b.add_theme_font_override("font", get_font())
	b.add_theme_font_size_override("font_size", FONT_SIZE)
	for state in ["font_color", "font_focus_color"]:
		b.add_theme_color_override(state, INK)
	b.add_theme_color_override("font_hover_color", BRASS)
	b.add_theme_color_override("font_pressed_color", BRASS)
	b.add_theme_color_override("font_disabled_color", Color("44474c"))
	var normal := StyleBoxFlat.new()
	normal.bg_color = PANEL
	normal.border_color = Color("15304a")
	normal.set_border_width_all(1)
	normal.set_content_margin_all(1)
	var hover := normal.duplicate()
	hover.border_color = BRASS_DARK
	var pressed := normal.duplicate()
	pressed.bg_color = Color("1d4060")
	pressed.border_color = BRASS
	for s in ["normal", "focus", "disabled"]:
		b.add_theme_stylebox_override(s, normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", pressed)
	# Text and size last: the minimum size must be measured with the 8 px font,
	# or the button keeps the height of Godot's default 16 px font.
	b.text = text
	b.position = pos
	b.size = size
	# Entering the tree can grow the button to the default theme's height;
	# put the intended size back once it's there.
	b.ready.connect(func() -> void: b.size = size, CONNECT_ONE_SHOT)
	b.pressed.connect(on_press)
	return b


static func set_selected(b: Button, selected: bool) -> void:
	b.add_theme_color_override("font_color", BRASS if selected else INK)
	var sb: StyleBoxFlat = b.get_theme_stylebox("normal").duplicate()
	sb.border_color = BRASS if selected else Color("15304a")
	b.add_theme_stylebox_override("normal", sb)


## A portrait texture, or a coloured placeholder bust when the art is missing.
static func portrait_texture(who: String) -> Texture2D:
	for path in ["res://art/portraits/%s.png" % who]:
		if ResourceLoader.exists(path):
			return load(path)
	var img := Image.create(64, 80, false, Image.FORMAT_RGBA8)
	var colours := {"aronnax": Color("27537a"), "conseil": Color("44474c"), "ned": Color("6a412f"),
		"nemo": Color("0f2236"), "farragut": Color("1d4060")}
	var body: Color = colours.get(who, Color("2a2c30"))
	img.fill(Color("0a1424"))
	for y in 80:
		for x in 64:
			var dx := x - 32
			if (dx * dx) / 18.0 + pow(y - 34, 2) / 30.0 < 18.0:
				img.set_pixel(x, y, Color("b87b58"))
			elif y > 54 and abs(dx) < 10 + (y - 54):
				img.set_pixel(x, y, body)
	return ImageTexture.create_from_image(img)
