extends Node

const max_board_occupancy=4
var board_occupancy=0

signal spawnEnemy(w,origin)

signal scoreIncrease(amt)
signal solderDecrease(amt)

signal missExpression

func _spawnEnemy(who,fromwho):
	spawnEnemy.emit(who,fromwho)

func _scoreIncrease(amt):
	scoreIncrease.emit(amt)
	
func _solderDecrease(amt):
	solderDecrease.emit(amt)

func _missExpression():
	missExpression.emit()

func keyPosition(key):
	match key:
		0: return Vector2(1,3)
		1: return Vector2(2,3)
		2: return Vector2(3,3)
		3: return Vector2(1,2)
		4: return Vector2(2,2)
		5: return Vector2(3,2)
		6: return Vector2(1,1)
		7: return Vector2(1,2)
		8: return Vector2(1,1)
