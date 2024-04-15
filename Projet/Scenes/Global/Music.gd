extends Node

const MIN_DB := -40.0
const MAX_DB := -10.0
const TRANS = 1.0

var current_music = null
var tween = null

func play(n : String):
	if !has_node(n):
		print("MUSIC ERROR: music '" + n + "' doesn't exist")
		return
	
	var former_music = current_music
	current_music = get_node(n)

	if former_music != null and former_music != current_music:
		if tween: tween.kill()
		
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_SINE)
		
		current_music.volume_db = MIN_DB
		tween.tween_property(former_music, "volume_db", MIN_DB, TRANS)
		tween.chain().tween_property(current_music, "volume_db", MAX_DB, TRANS)
		tween.tween_callback(former_music.stop)
	
	current_music.play()
