extends Node

const max_board_occupancy=4
var board_occupancy=0

signal spawnEnemy(w,origin)

signal scoreIncrease(amt)
signal solderDecrease(amt)

func _spawnEnemy(who,fromwho):
	spawnEnemy.emit(who,fromwho)

func _scoreIncrease(amt):
	scoreIncrease.emit(amt)
	
func _solderDecrease(amt):
	solderDecrease.emit(amt)
