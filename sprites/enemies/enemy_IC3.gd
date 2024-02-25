extends AnimatedSprite2D

var daddy

func activate():
	daddy=get_parent().whospawnedme
	#teleport to square next to daddy
	
func _process(_delta):
	if is_instance_valid(get_parent().whospawnedme):
		if get_parent().whospawnedme.dead == true:
		#	touchable = true
		#	animation="default_vulnerable"
			set_process(false)
	else:
	#	touchable=true
	#	animation="default_vulnerable"
		set_process(false)

func _on_timer_timeout():
	Global.board_occupancy-=1
	get_parent().queue_free()
func unalive():
	get_parent().dead=true
	$"../smushed".start()
	$Timer.stop()
	animation="unalive"
	material.set_shader_parameter("flashing",true)
	Global._scoreIncrease(3)
