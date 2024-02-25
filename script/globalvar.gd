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
		7: return Vector2(2,1)
		8: return Vector2(3,1)

func v2Position(v2:Vector2):
	match v2:
		Vector2(1,3): return 0
		Vector2(2,3): return 1
		Vector2(3,3): return 2
		Vector2(1,2): return 3
		Vector2(2,2): return 4
		Vector2(3,2): return 5
		Vector2(1,1): return 6
		Vector2(2,1): return 7
		Vector2(3,1): return 8
		
