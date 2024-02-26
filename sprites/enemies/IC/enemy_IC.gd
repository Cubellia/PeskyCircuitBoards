extends AnimatedSprite2D

func activate():
	get_child(0).paused=false
	get_child(0).start()

func _on_timer_timeout():
	Global._spawnEnemy(1,get_parent()) #replace self (faking movement)
	Global.board_occupancy-=1
	get_parent().queue_free()
	
	
func unalive():
	get_parent().dead=true
	$"../smushed".start()
	$Timer.stop()
	animation="unalive"
	material.set_shader_parameter("flashing",true)
	Global._spawnEnemy(2,get_parent())
