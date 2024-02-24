extends AnimatedSprite2D

func activate():
	Global._spawnEnemy(2,get_parent())

func unalive():
	get_parent().dead=true
	$"../smushed".start()
	$Timer.stop()
	animation="unalive"
	material.set_shader_parameter("flashing",true)
