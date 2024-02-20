extends ColorRect


func _process(delta):
	if Input.is_action_just_pressed("nokia_0")&&get_tree().paused == true:
			get_tree().paused == false
			$".."._reloadgame()
			
