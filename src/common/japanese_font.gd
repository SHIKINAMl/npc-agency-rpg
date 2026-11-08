## [npc-agency-rpg] 日本語表示のためのフォント設定（autoload: JapaneseFont）。
##
## 上流のフォント（Kenney Pixel / SourceCodePro）と既定テーマのフォントには日本語グリフがない。
## デスクトップでは OS のフォントで代替表示されるが、Web（HTML5）エクスポートでは
## システムフォントへのフォールバックが効かず文字が豆腐になる。
## そこで起動時に、使われているすべてのフォントのフォールバックに DotGothic16 を追加する。
## （.theme はバイナリ形式で差分が追いにくいため、テーマ自体は編集せずここで対処する。）
extends Node

const JP_FONT: Font = preload("res://assets/gui/font/DotGothic16-Regular.ttf")

const UPSTREAM_FONT_PATHS: = [
	"res://assets/gui/font/Kenney Pixel.ttf",
	"res://assets/gui/font/SourceCodePro-Bold.ttf",
]

const THEME_PATHS: = [
	"res://assets/gui/default.theme",
	"res://src/combat/ui/ui_combat.theme",
]


func _init() -> void:
	var fonts: Array[Font] = []

	for path in UPSTREAM_FONT_PATHS:
		var font: = load(path) as Font
		if font:
			fonts.append(font)

	# Fonts used by the themes (both the theme's default font and any per-type font).
	var themes: Array[Theme] = [ThemeDB.get_project_theme(), ThemeDB.get_default_theme()]
	for path in THEME_PATHS:
		themes.append(load(path) as Theme)
	for theme in themes:
		if not theme:
			continue
		if theme.default_font:
			fonts.append(theme.default_font)
		for type_name in theme.get_font_type_list():
			for font_name in theme.get_font_list(type_name):
				fonts.append(theme.get_font(font_name, type_name))

	fonts.append(ThemeDB.fallback_font)

	for font in fonts:
		_add_japanese_fallback(font)


func _add_japanese_fallback(font: Font) -> void:
	if font == null or font == JP_FONT or JP_FONT in font.fallbacks:
		return

	var fallbacks: = font.fallbacks.duplicate()
	fallbacks.append(JP_FONT)
	font.fallbacks = fallbacks
