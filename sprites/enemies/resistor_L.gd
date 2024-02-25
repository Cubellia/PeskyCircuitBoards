extends AnimatedSprite2D
var failsfx =preload("res://sfx/hitfail.mp3")
var daddy=null
var smushed = false
func activate():
	
	var yy= get_parent().whereami.y
	if yy==3: translate(Vector2(1,0))
	elif yy==2: translate(Vector2(2,0))
	elif yy==	1: translate(Vector2(4,0))
	
	
	
func _process(_delta):
	if daddy != null:
		if is_instance_valid(get_parent().whospawnedme):
			daddy.find_child("enemy_resistor_R").son=self
			set_frame_and_progress(0,0)
			set_process(false)
	else:daddy=get_parent().whospawnedme
func _on_timer_timeout():
	Global.board_occupancy-=1
	get_parent().queue_free()
func unalive():
	if daddy.find_child("enemy_resistor_R").smushed==true:
		smushed=true
		get_parent().dead=true
		daddy.find_child("enemy_resistor_R").fakeunalive()
		$"../smushed".start()
		$Timer.stop()
		animation="unalive"
		material.set_shader_parameter("flashing",true)
		Global._scoreIncrease(3)
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
