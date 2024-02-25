extends AnimatedSprite2D

func activate():
	get_child(0).paused=false
	get_child(0).start()

func _on_timer_timeout():
	Global._spawnEnemy(0,get_parent())
	Global.board_occupancy-=1
	get_parent().queue_free()
	
	
func unalive():
	get_parent().dead=true
	$"../smushed".start()
	$Timer.stop()
	animation="unalive"
	material.set_shader_parameter("flashing",true)
	Global._scoreIncrease(1)
