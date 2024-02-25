extends AnimatedSprite2D

var touched = false

func activate():
	if(get_parent().whereami.x==1):
		print("whoops nevermind")
		get_parent().queue_free()
	Global._spawnEnemy(8,get_parent())

func unalive():
	if not touched:
		touched = true
		animation="unalive"
		#Global._solderDecrease(1)
	else:
		get_parent().dead=true
		$"../smushed".start()
		$Timer.stop()
		animation="unalive"
		material.set_shader_parameter("flashing",true)
