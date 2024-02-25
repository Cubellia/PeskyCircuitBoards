extends AnimatedSprite2D

var touched = false

var son

func activate():
	
	print("I AM A RESTITOR AAAAA "+str(get_parent().whereami.x) )
	if(get_parent().whereami.x==1):
		print("whoops nevermind")
		get_parent().queue_free()
	else:
		Global._spawnEnemy(8,get_parent())

#func _process(_delta):
	#if son !=null:
		#if is_instance_valid(son):
			#if son.dead == true:
				#touchable = true
				#animation="default_vulnerable"
				#set_process(false)
		#else:
			#touchable=true
			#animation="default_vulnerable"
			#set_process(false)


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
