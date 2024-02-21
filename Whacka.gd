extends Node2D

@export var slots:Node2D
@export var iron:Node2D
@export var sfx:AudioStreamPlayer
@export var score:Label
@export var solder:TextureProgressBar
@export var character:Node2D
var enemy = preload("res://enemy.tscn")
var enemies = []

var sfx_good=preload("res://sfx/good2.wav")
var sfx_neutral=preload("res://sfx/blip4.wav")
var music_gameOver=preload("res://music/negative1.wav")
var music_main=preload("res://music/nokia.wav")
var sfx_restart=preload("res://sfx/good3.wav")
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if(event.as_text_key_label().contains("Kp ")&&get_tree().paused==false):
				for action in InputMap.get_actions():#this is absolutely disgusting. do i really have to???? ffs
					if InputMap.action_has_event(action, event):
						var k = action.split('_')[1];
						if not k=="0" && not k=="#"&&not k=="*":
							var zof = 6
							if int(k)<=3:
								zof=6
							elif int(k)>=4 && int(k)<=6:
								zof = 8
							else:
								zof=10
							iron.z_index=zof
							var square = slots.find_child("square"+k)
							iron.global_position=square.global_position
							iron.find_child("AnimationPlayer").seek(0.0)
							iron.find_child("AnimationPlayer").play("poke")
							character.find_child("CharAnim").seek(0.0)
							character.find_child("CharAnim").play("Solder")
							if square.get_child_count()>0:
								if not square.get_child(0).dead:
									score.text=str(int(score.text)+1)
									sfx.stream=sfx_good
									sfx.play(0.0)
									square.get_child(0).unalive()
									#THIS IS TEMPORARY until we add health packs or smth
									solder.value+=1
								else:
									if solder.value==1:
										_gameOver()
									else:
										solder.value-=1
							else:
								sfx.stream=sfx_neutral
								sfx.play(0.0)
								if solder.value==1:
									_gameOver()
								else:
									solder.value-=1

						
#func _process(delta):
func _reloadgame():
	get_tree().paused=false
	for square in slots.get_children():
		if square.get_child_count()>0:
			square.get_child(0).queue_free()

	solder.value=solder.max_value
	score.text="0"
	print("reload game")
	$MenuAnim.play("RESET")
	$Music.stream=music_main
	$Music.play()

func _gameOver():
	get_tree().paused = true
	$MenuAnim.play("GAMEOVER")
	$Music.stream=music_gameOver
	$Music.play()
	$GameOver/FinalScore.text="Score: "+score.text
	print("YOU lOSE")

func _on_spawn_time_timeout():
	var randomtile = randi_range(0,8)
	if slots.get_child(randomtile).get_child_count()==0:
		var e = enemy.instantiate()
		slots.get_child(randomtile).add_child(e)
		e.position=Vector2.ZERO
		
