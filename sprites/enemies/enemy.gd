extends Node2D

var dead=false

var whospawnedme

@export var validEnemies:Array[AnimatedSprite2D]

var whoami

func pickType(rng:int,bypass:bool=false):
	var rngo=rng
	var enemyType=	get_child(rng)
	if bypass== false:
		while not enemyType in validEnemies:
			rngo=(rngo+1)%(validEnemies.size()+1)
			enemyType=get_child(rngo)
	enemyType.visible=true
	enemyType.activate()
	whoami=enemyType

func unalive():
	whoami.unalive()


func _on_smushed_timeout():
	queue_free()
	Global.board_occupancy-=1
