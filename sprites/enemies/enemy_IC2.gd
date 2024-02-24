extends AnimatedSprite2D

func activate():
	pass
	#print("activated IC")

func _on_timer_timeout():
	Global.board_occupancy-=1
	get_parent().queue_free()
func unalive():
	get_parent().dead=true
	$"../smushed".start()
	$Timer.stop()
	animation="unalive"
	material.set_shader_parameter("flashing",true)
	var variant = randi_range(0,1)
	Global._spawnEnemy(5+variant,get_parent())
