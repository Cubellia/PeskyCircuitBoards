extends AnimatedSprite2D


func activate():
	pass
	
func unalive():
	get_parent().dead=true
	$"../smushed".start()
	$Timer.stop()
	animation="unalive"
	material.set_shader_parameter("flashing",true)
	Global._scoreIncrease(5)
