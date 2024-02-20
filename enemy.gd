extends Node2D

var dead=false
func unalive():
	dead=true
	$smushed.start()
	for c in get_children():
		if c.name.contains("enemy_")&&c.visible:
			c.find_child("Timer").stop()
			c.pause()
			c.material.set_shader_parameter("flashing",true)

func _on_smushed_timeout():
	queue_free()
