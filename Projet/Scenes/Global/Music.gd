extends Node

const MIN_DB := -50.0
const TRANS = 2.0

var current_music = null
var tween = null

func play(n : String):
	if !has_node(n):
		print("MUSIC ERROR: music '" + n + "' doesn't exist")
		return
	
	var former_music = current_music
	current_music = get_node(n)
	current_music.play()

	if former_music != null:
		if tween: tween.kill()
		
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_SINE)
		
		tween.tween_property(former_music, "volume_db", MIN_DB, TRANS).chain().tween_property(current_music, "volume_db", -5, TRANS).tween_callback(former_music.stop)
