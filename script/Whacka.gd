extends Node2D

@export var slots:Node2D
@export var iron:Node2D
@export var sfx:AudioStreamPlayer
@export var score:Label
@export var solder:TextureProgressBar
@export var character:Node2D
var enemy = preload("res://sprites/enemies/enemy.tscn")
var enemies = []
var jitterTween 
@export var jitterSpeed = 0.05

var sfx_good=preload("res://sfx/good2.wav")
var sfx_neutral=preload("res://sfx/blip4.wav")
var music_gameOver=preload("res://music/negative1.wav")
var music_main=preload("res://music/nokia.wav")
var sfx_restart=preload("res://sfx/good3.wav")

var unlocked_enemies=2



func _ready():
	AudioManager.play_music(music_main)
	Global.spawnEnemy.connect(_spawnEnemy)
	Global.solderDecrease.connect(_solderDecrease)
	Global.scoreIncrease.connect(_scoreIncrease)
func _solderDecrease(amt):
	if solder.value-amt<=0:
		_gameOver()
	else:solder.value-=amt
	
func _scoreIncrease(amt):
	score.text=str(int(score.text)+amt)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if(event.as_text_key_label().contains("Kp ")&&get_tree().paused==false):
				for action in InputMap.get_actions():#this is absolutely disgusting. do i really have to???? ffs
					if InputMap.action_has_event(action, event):
						##isolate the number of the nokia keypad key, and ignore the irrelevant ones
						var k = action.split('_')[1];
						if not k=="0" && not k=="#"&&not k=="*":
							#get the active column for the eyes to look at
							var zof = 6
							if int(k)<=3:
								zof=6
							elif int(k)>=4 && int(k)<=6:
								zof = 8
							else:
								zof=10
							iron.z_index=zof
							var column = (int(k)-1)%3
							#print(column)
							character.find_child("face").frame=column
							
							##find the square based on the input key and make the human stab it
							var square = slots.find_child("square"+k)
							iron.global_position=square.global_position
							iron.find_child("AnimationPlayer").seek(0.0)
							iron.find_child("AnimationPlayer").play("poke")
							
							iron.find_child("Shadow").play("default")
							character.find_child("GogglePlayer").seek(0.0)
							character.find_child("GogglePlayer").play("RESET")
							
							##check to see if the square has an enemy on it
							if square.get_child_count()>0:
								if not square.get_child(0).dead: ##if the enemy is alive
									
								
									#sfx.stream=sfx_good
									character.find_child("FacePlayer").seek(0.0)
									character.find_child("FacePlayer").play("Success")
									#character.find_child("face").frame = 3
									#sfx.play(0.0)
									AudioManager.play_sfx(sfx_good)
									square.get_child(0).unalive()
									
									#THIS IS TEMPORARY? until we add health packs or smth?
									solder.value+=1
								else:  ##if the enemy is dead already
									_solderDecrease(1)
							
							
							else:  ##if there is nothing on the square
								###PLAYER FAIL STATE###
								#sfx.stream=sfx_neutral
								if jitterTween:
									jitterTween.kill() #Aborts previous anim
								jitterTween = get_tree().create_tween()
								jitterTween.tween_property($Bkg/Chara, "position", Vector2(-2, -1), jitterSpeed).set_trans(Tween.TRANS_LINEAR)
								jitterTween.set_loops(2)
								jitterTween.tween_property($Bkg/Chara, "position", Vector2(0, -1), jitterSpeed) .set_trans(Tween.TRANS_LINEAR) 
								character.find_child("FacePlayer").seek(0.0)
								character.find_child("FacePlayer").play("Failure")
								character.find_child("GogglePlayer").seek(0.0)
								character.find_child("GogglePlayer").play("Solder")
								
								#character.find_child("face").frame = 4
								#sfx.play(0.0)
								AudioManager.play_sfx(sfx_neutral)
								_solderDecrease(1)


						
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
	#$Music.stream=music_main
	#$Music.play()
	AudioManager.play_music(music_main)
func _gameOver():
	get_tree().paused = true
	$MenuAnim.play("GAMEOVER")
	#$Music.stream=music_gameOver
	#$Music.play()
	AudioManager.play_music(music_gameOver)
	$GameOver/FinalScore.text="Score: "+score.text
	print("YOU lOSE")

func _spawnEnemy(who,fromwho):
	print ("Spawn "+str(who))
	if Global.board_occupancy < 8:
		var randomtile = randi_range(0,8)
		if slots.get_child(randomtile).get_child_count()==0:
			var e = enemy.instantiate()
			slots.get_child(randomtile).add_child(e)
			Global.board_occupancy+=1
			e.pickType(who,true)
			e.whospawnedme=fromwho
func _on_spawn_time_timeout():
	if Global.board_occupancy < Global.max_board_occupancy:
		var randomtile = randi_range(0,8)
		if slots.get_child(randomtile).get_child_count()==0:
			var e = enemy.instantiate()
			slots.get_child(randomtile).add_child(e)
		
			#set self destruct timer. this cant be turned on until after its added to the tree
			Global.board_occupancy+=1
			e.pickType(randi_range(0,unlocked_enemies))
			e.position=Vector2.ZERO
			
		
