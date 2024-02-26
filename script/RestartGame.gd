extends ColorRect


func _process(delta):
	if Input.is_action_just_pressed("nokia_0")&&get_tree().paused == true:
		$WaitForCoolFace.paused=false
		$WaitForCoolFace.start()
		$AnimatedSprite2D.play("ready")


func _on_wait_for_sleepy_face_timeout():
	$AnimatedSprite2D.play("snooze")

func _actuallyRestart():
	get_tree().paused == false
	$".."._reloadgame()


func _on_wait_for_cool_face_timeout():
	_actuallyRestart()
