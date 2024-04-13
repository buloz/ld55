extends Node

#TODO: Réfléchir à si on veut utiliser la vélocity et donc forcer les character body sur les mobs, ou si on utiliser notre propre système de déplacement.
#      et qu'on rajoute une propriété "target" aux entités qui recoive notre component, et qui traite ensuite le déplacement dans leur script (je pense c'est mieux)

#TODO: Utiliser cette valeur (PlayerTeam) pour savoir si l'entité doit courir vers une entité de l'équipe du joueur ou vers un mob (pour une invocation du joueur par exemple)

#Il va falloir utiliser un algo un minimum performant pour savoir vers quel mob courrir
#idée: avoir un area 2D symbolisant la portée d'agro de notre mob (ou portée d'attaque si il ne se déplace pas ou qu'il se déplace vers le joueur)
#et agir quand une entitée de la boite de collision ennemi rentre dans l'area

#Pareil pour les mobs mais si personne dans leur area courrir vers le joueur par défaut ?


#Indicate if the entity is in the player team or not
@export var PlayerTeam: bool = false


#TODO: ces attributs là devrait être stocké dans un component de l'entité qui contient ses propriété (range, speed, etc)
#A quel distance l'ennemi doit allez de la cible
@export var foeDistance: float = 0.0
@export var speed: float = 300.0


#TODO: Courir sur l'entité de la team ennemie la plus proche
func _process(_delta):
	
	var distanceToTarget: float = get_parent().position.distance_to(get_node("/root/Global").playerPosition)
	
	if distanceToTarget > foeDistance:
		get_parent().velocity = (get_node("/root/Global").playerPosition - get_parent().position).normalized() * speed
	else:
		get_parent().velocity = Vector2.ZERO
