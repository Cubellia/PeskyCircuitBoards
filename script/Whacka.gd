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
var music_title =preload("res://music/titlescreenmayb.mp3")
var sfx_good=preload("res://sfx/hit6.wav")
var sfx_neutral=preload("res://sfx/blip4.wav")
var music_gameOver=preload("res://music/negative1.wav")
var music_main=preload("res://music/nokia.wav")
var sfx_restart=preload("res://sfx/good3.wav")

var title=true

var unlocked_enemies=4
func readyGame():
	title=false
	$TitleScreen/TitleAnim.play("reset")
	_reloadgame()
func _ready():
	AudioManager.play_music(music_title)
	$TitleScreen/TitleAnim.play("TitleIntro" )
	get_tree().paused = true
	Global.spawnEnemy.connect(_spawnEnemy)
	Global.solderDecrease.connect(_solderDecrease)
	Global.scoreIncrease.connect(_scoreIncrease)
	Global.missExpression.connect(_failExpression)
func _solderDecrease(amt):
	if solder.value-amt<=0:
		_gameOver()
	else:solder.value-=amt
	
func _scoreIncrease(amt):
	score.text=str(int(score.text)+amt)

func _process(delta):
			if title==true:
				if Input.is_anything_pressed():
					readyGame()
			if title==false && get_tree().paused:
				title = true #dont worry if this doesnt make sense by ear, im lazy
				get_tree().paused=false
				
			if(get_tree().paused==false):
				var pressed = false
				var k=0
				##i feel filthy. i feel like i am yanderedev. i am not a coder. i will never be a coder. i am ashamed. i will one day stand before god for my crimes. juan help me.
				if Input.is_action_just_pressed("nokia_1"):
					k=1
					pressed=true
				elif Input.is_action_just_pressed("nokia_2"):
					k=2
					pressed=true
				elif Input.is_action_just_pressed("nokia_3"):
					k=3
					pressed=true
				elif Input.is_action_just_pressed("nokia_4"):
					k=4
					pressed=true
				elif Input.is_action_just_pressed("nokia_5"):
					k=5
					pressed=true
				elif Input.is_action_just_pressed("nokia_6"):
					k=6
					pressed=true
				elif Input.is_action_just_pressed("nokia_7"):
					k=7
					pressed=true
				elif Input.is_action_just_pressed("nokia_8"):
					k=8
					pressed=true
				elif Input.is_action_just_pressed("nokia_9"):
					k=9
					pressed=true
				if pressed:
					$SolderDepleter.start()#reset the solder depleter timer if the player isnt inactive
					#get the active column for the eyes to look at
					var zof = 6
					if k<=3:
						zof=6
					elif k>=4 && k<=6:
						zof = 8
					else:
						zof=10
					iron.z_index=zof
					var column = (k-1)%3
					#print(column)
					character.find_child("face").frame=column
					
					##find the square based on the input key and make the human stab it
					var square = slots.find_child("square"+str(k))
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

						_failExpression()
						#character.find_child("face").frame = 4
						#sfx.play(0.0)
						AudioManager.play_sfx(sfx_neutral)
						_solderDecrease(1)



func _failExpression():
	character.find_child("FacePlayer").seek(0.0)
	character.find_child("FacePlayer").play("Failure")
	character.find_child("GogglePlayer").seek(0.0)
	character.find_child("GogglePlayer").play("Solder")

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
	$SpawnTime.paused=false
	$SpawnTime.start()
	#$Music.stream=music_main
	#$Music.play()
	AudioManager.play_music(music_main)
	AudioManager.play_sfx(sfx_restart)
	
	
func _gameOver():
	get_tree().paused = true
	$MenuAnim.play("GAMEOVER")
	#$Music.stream=music_gameOver
	#$Music.play()
	AudioManager.play_music(music_gameOver)
	AudioManager.play_sfx(music_gameOver)
	$GameOver/FinalScore.text="Score: "+score.text
	$GameOver/WaitForSleepyFace.paused=false
	$GameOver/WaitForSleepyFace.start()
	$GameOver/AnimatedSprite2D.play("default")
	print("YOU lOSE")

func _spawnEnemy(who,fromwho):
	#print ("Spawn "+str(who))
	var overwritePosition=null
	##all of this is JUST for the resistor
	for g in fromwho.get_children():
		if g.name.contains("resistor_R")&&g.visible==true:

			var whereami= Global.keyPosition(int(g.get_parent().get_parent().name.split("square")[1])-1)

			var targetposition = Vector2(whereami.x-1,whereami.y)

			var pp = Global.v2Position(targetposition)

			if slots.get_child(pp).get_child_count()>0:
				print(str(slots.get_child(pp))+" has child")
				fromwho.queue_free()
				Global.board_occupancy-=1
				return
			else:
				overwritePosition=targetposition
				#print("ovrpos "+str(overwritePosition))
	##now the ACTUAL spawn enemy code
	if Global.board_occupancy < 8:
		var randomtile = randi_range(0,8)
		if overwritePosition !=null:
			randomtile = Global.v2Position(overwritePosition)#haha im lazy
		while slots.get_child(randomtile).get_child_count()!=0:
			randomtile=(randomtile+1)%9
		#if slots.get_child(randomtile).get_child_count()==0:
		var e = enemy.instantiate() 
		slots.get_child(randomtile).add_child(e)
		Global.board_occupancy+=1
		e.pickType(who,Global.keyPosition(randomtile),true)
		e.whospawnedme=fromwho
			
func _on_spawn_time_timeout():
	
	if Global.board_occupancy < Global.max_board_occupancy:
		var randomtile = randi_range(0,8)
		if slots.get_child(randomtile).get_child_count()==0:
			var e = enemy.instantiate()
			slots.get_child(randomtile).add_child(e)
		
			#set self destruct timer. this cant be turned on until after its added to the tree
			Global.board_occupancy+=1
			
			e.pickType(randi_range(0,unlocked_enemies),Global.keyPosition(randomtile))
			e.position=Vector2.ZERO

func _on_solder_depleter_timeout():
	_solderDecrease(1)
