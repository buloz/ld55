extends Node

#TODO: Réfléchir à si on veut utiliser la vélocity et donc forcer les character body sur les mobs, ou si on utiliser notre propre système de déplacement.
#      et qu'on rajoute une propriété "target" aux entités qui recoive notre component, et qui traite ensuite le déplacement dans leur script (je pense c'est mieux)

#TODO: Utiliser cette valeur (PlayerTeam) pour savoir si l'entité doit courir vers une entité de l'équipe du joueur ou vers un mob (pour une invocation du joueur par exemple)

#Il va falloir utiliser un algo un minimum performant pour savoir vers quel mob courrir
#idée: avoir un area 2D symbolisant la portée d'agro de notre mob (ou portée d'attaque si il ne se déplace pas ou qu'il se déplace vers le joueur)
#et agir quand une entitée de la boite de collision ennemi rentre dans l'area

#Pareil pour les mobs mais si personne dans leur area courrir vers le joueur par défaut ?


#Indicate if the entity is in the player team or not
var playerTeam: bool


func _ready():
	playerTeam = get_parent().playerTeam
	$Area2D.collision_mask = 0b01
	
	if playerTeam:
		$Area2D.collision_mask <<= 1


func _physics_process(_delta):
	if Engine.get_physics_frames() % 3 != 0:
		return
	
	get_parent().hasTarget = false
	
	#To compute the s target
	var shortestDistance = 100000000000
	
	if $Area2D.has_overlapping_areas():
		var targetBody
		for body in $Area2D.get_overlapping_areas():
			var dist : float = get_parent().global_position.distance_to(body.global_position)
			if dist < shortestDistance:
				targetBody = body
				shortestDistance = dist
		
		#print("Target position: ", targetBody.global_position, ", ", targetBody.get_parent().name)
		get_parent().targetPosition = targetBody.global_position
		get_parent().hasTarget = true
	
	if not playerTeam:
		var playerDist: float = get_parent().position.distance_to(get_node("/root/Global").playerPosition)
		
		if playerDist < shortestDistance:
			get_parent().hasTarget = true
			get_parent().targetPosition = get_node("/root/Global").playerPosition
