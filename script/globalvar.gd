extends Node

const max_board_occupancy=4
var board_occupancy=0

signal spawnEnemy(w,origin)

func _spawnEnemy(who,fromwho):
	spawnEnemy.emit(who,fromwho)
