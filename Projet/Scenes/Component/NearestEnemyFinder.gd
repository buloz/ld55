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


#TODO: Courir sur l'entité de la team ennemie la plus proche
func _process(_delta):
	
	get_parent().hasTarget = false
	
	if $Area2D.has_overlapping_bodies():
		
		var targetBody
		var shortestDistance = 1000000
		for body in $Area2D.get_overlapping_bodies():
			var dist : float = get_parent().position.distance_to(body.position)
			if dist < shortestDistance:
				targetBody = body
			
		get_parent().targetPosition = targetBody.position
		get_parent().hasTarget = true
	
	else:

		if not playerTeam:
			get_parent().hasTarget = true
			get_parent().targetPosition = get_node("/root/Global").playerPosition
			
		
