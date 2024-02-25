extends Node2D

var dead=false

var whospawnedme

@export var validEnemies:Array[AnimatedSprite2D]

var whoami
var whereami:Vector2

func pickType(rng:int,location:Vector2,bypass:bool=false):
	#print("want to spawn "+str(rng)+" out of "+str(get_child_count()))
	var rngo=rng
	var enemyType=	get_child(rng)
	if bypass == false:
		while not enemyType in validEnemies:
		#	rngo=(rngo+1)%(validEnemies.size()+1)
			rngo=(rngo+1)%(get_child_count())
			#print("iterate"+str( rngo))
			enemyType=get_child(rngo)
	enemyType.visible=true
	whoami=enemyType
	whereami=location
	enemyType.activate()
func move_adjacent():
	var thissquare=int(get_parent().name.split("square")[1])
	#get_parent().get_parent().

func unalive():
	whoami.unalive()


func _on_smushed_timeout():
	queue_free()
	Global.board_occupancy-=1
