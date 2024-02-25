extends AnimatedSprite2D

var touchable=false
var failsfx =preload("res://sfx/hitfail.mp3")


func activate():
	set_process(true)
func unalive():
	if touchable:
		get_parent().dead=true
		$"../smushed".start()
		$Timer.stop()
		animation="unalive"
		material.set_shader_parameter("flashing",true)
		Global._scoreIncrease(2)
	else:
		AudioManager.play_sfx(failsfx)
		Global._solderDecrease(2)
		Global._missExpression()
func _process(_delta):
	if is_instance_valid(get_parent().whospawnedme):
		if get_parent().whospawnedme.dead == true:
			touchable = true
			animation="default_vulnerable"
			set_process(false)
	else:
		touchable=true
		animation="default_vulnerable"
		set_process(false)
