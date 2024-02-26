extends AnimatedSprite2D

var touched = false

var son:AnimatedSprite2D=null

var smushed =false
var failsfx =preload("res://sfx/hitfail.mp3")
func activate():
	
	
	if(get_parent().whereami.x==1):
	
		Global.board_occupancy-=1
		get_parent().queue_free()
	else:
		
		Global._spawnEnemy(6,get_parent())
		var yy =get_parent().whereami.y

		if yy==3:##ok now i really AM yanderedev. why the FUCK is match not working i dont understand

				translate(Vector2(-1,0))
		elif yy==2: 
				translate(Vector2(-3,0))
		elif yy==1: 
				translate(Vector2(-4,0))
			 
func _process(_delta):
	if son !=null:
		#if is_instance_valid(son):
			#if son.dead == true:
				#touchable = true
				#animation="default_vulnerable"
				#set_process(false)
		#else:
			#touchable=true
			#animation="default_vulnerable"
			#set_process(false)
		set_frame_and_progress(0,0)
		set_process(false)

func unalive():
	if son!=null:
		if son.smushed:
			smushed=true
			son.fakeunalive()
			get_parent().dead=true
			$"../smushed".start()
			$Timer.stop()
			animation="unalive"
			material.set_shader_parameter("flashing",true)
		else:
			if smushed:
				AudioManager.play_sfx(failsfx)
				Global._solderDecrease(2)
				Global._missExpression()
			else:
				smushed=true
				animation="unalive"

func fakeunalive():

	get_parent().dead=true
	$"../smushed".start()
	$Timer.stop()
	animation="unalive"
	material.set_shader_parameter("flashing",true)
