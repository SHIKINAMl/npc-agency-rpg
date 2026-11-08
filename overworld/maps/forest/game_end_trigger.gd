@tool
extends Trigger

## [npc-agency-rpg] 上流ではゴーストが飛びかかって即エンディングだったが、
## シナリオを完結させるため「会話 → ゴーストとの戦闘 → 勝利後の会話 → エンディング」にした。
## 戦闘に負けた場合は短い台詞のあと再戦する（条件間でクリアできる/できないの差が出ないように）。

## The time (in seconds) into the "lunge" animation at which the ghost has finished leaping at the
## player, just before the animation starts fading in the win screen.
const LUNGE_ATTACK_LENGTH: = 1.05

@export var timeline: DialogicTimeline
@export var victory_timeline: DialogicTimeline
@export var loss_timeline: DialogicTimeline
@export var combat_arena: PackedScene
@export var ghost_animation_player: AnimationPlayer

var gamepiece: Gamepiece

@onready var _timer: = $Timer as Timer


func _execute() -> void:
	gamepiece.move_to(Gameboard.cell_to_pixel(Vector2i(53, 30)))
	await gamepiece.arrived

	_timer.start()
	await _timer.timeout

	Dialogic.start_timeline(timeline)
	await Dialogic.timeline_ended

	_timer.start()
	await _timer.timeout

	var did_player_win: = false
	while not did_player_win:
		# The ghost leaps at the player (the first part of the lunge animation), and combat begins.
		ghost_animation_player.play("lunge")
		await get_tree().create_timer(LUNGE_ATTACK_LENGTH).timeout
		ghost_animation_player.pause()

		FieldEvents.combat_triggered.emit(combat_arena)
		did_player_win = await CombatEvents.combat_finished

		# Put the ghost back in place while the screen is still covered.
		ghost_animation_player.play("RESET")

		# The combat ends with a covered screen, and so we fix that here.
		Transition.clear.call_deferred(0.2)
		await Transition.finished

		Dialogic.start_timeline(victory_timeline if did_player_win else loss_timeline)
		await Dialogic.timeline_ended

	await _show_win_screen()

	# Lock input by waiting for a signal that won't trigger.
	await ready


# Fade in the win screen, matching the timing of the end of the upstream "lunge" animation.
func _show_win_screen() -> void:
	var screen: = ghost_animation_player.get_node("WinScreen/ColorRect") as CanvasItem
	var text: = screen.get_node("VBoxContainer/VBoxContainer") as CanvasItem

	screen.modulate.a = 0.0
	text.modulate.a = 0.0
	screen.show()

	var tween: = create_tween()
	tween.tween_property(screen, "modulate:a", 1.0, 0.3)
	tween.tween_interval(0.4)
	tween.tween_property(text, "modulate:a", 1.0, 0.7)
	await tween.finished


func _on_area_entered(area: Area2D) -> void:
	if not Engine.is_editor_hint():
		gamepiece = area.owner as Gamepiece
	super._on_area_entered(area)
