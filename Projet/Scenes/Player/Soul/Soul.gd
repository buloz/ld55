extends Node2D

var soulSize: float = 1.0

#func _ready():
	#get_tree().create_timer(2.0).timeout.connect(remove)

func remove():
	
	#Stop emitting particules
	$GPUParticles2D.amount_ratio = 0.0

	#We need to set emitting to false then true after one shot for the sign to work
	#Bug link: https://github.com/godotengine/godot/issues/85802
	$GPUParticles2D.emitting = false
	$GPUParticles2D.one_shot = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D.emitting = false
	
	#Remove the free here if you want to keep the particles for a short period of time
	queue_free()

func _on_area_2d_body_entered(body):
	
	get_node("/root/Global").Player.gatherSoul(soulSize)
	
	$Area2D.set_deferred("monitoring", false)
	
	#Delete sprite
	$Sprite2D.queue_free()
	
	remove()
	

func _on_gpu_particles_2d_finished():
	queue_free()
