@tool
extends CombatTrigger

## [npc-agency-rpg] Optional dialogues played before combat and after a victory or loss.
@export var pre_combat_timeline: DialogicTimeline
@export var victory_timeline: DialogicTimeline
@export var loss_timeline: DialogicTimeline


func _execute() -> void:
	if pre_combat_timeline:
		Dialogic.start_timeline(pre_combat_timeline)
		await Dialogic.timeline_ended
	
	await super._execute()


# If the player has defeated this 'roaming encounter', remove the encounter.
func _run_victory_cutscene() -> void:
	if victory_timeline:
		Dialogic.start_timeline(victory_timeline)
		await Dialogic.timeline_ended
	
	queue_free()


# If the player has lost to this 'roaming encounter', play the game-over screen.
func _run_loss_cutscene() -> void:
	if loss_timeline:
		Dialogic.start_timeline(loss_timeline)
		await Dialogic.timeline_ended
	
	await get_tree().process_frame
