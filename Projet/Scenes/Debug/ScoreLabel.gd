extends Label

var player:PlayerClass
var score = 0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.scored.connect(_update_score)

func _update_score(value : int):
	text = "Score : %s" % str(player.score + value)
