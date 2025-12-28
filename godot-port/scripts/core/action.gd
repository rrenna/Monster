## Action - Container for a sequence of moves
## Ported from MAction.h/mm
class_name Action
extends RefCounted

var moves: Array[Move] = []


func _init(p_moves: Array[Move] = []) -> void:
	moves = p_moves


## Create an action with a single move
static func create_single(move: Move) -> Action:
	var action = Action.new()
	action.moves.append(move)
	return action


## Create an action with multiple moves
static func create_multi(p_moves: Array[Move]) -> Action:
	return Action.new(p_moves)


## Add a move to this action
func add_move(move: Move) -> void:
	moves.append(move)


## Get the first move in the sequence
func get_first_move() -> Move:
	if moves.is_empty():
		return null
	return moves[0]


## Get the last move in the sequence
func get_last_move() -> Move:
	if moves.is_empty():
		return null
	return moves[moves.size() - 1]


## Get the total move cost
func get_total_move_cost() -> int:
	var total: int = 0
	for move in moves:
		if move.skill:
			total += move.skill.move_cost
		else:
			total += 1
	return total


## Get the starting position of this action
func get_start_position() -> Vector2i:
	var first = get_first_move()
	if first:
		return first.source_position
	return Vector2i.ZERO


## Get the ending position of this action
func get_end_position() -> Vector2i:
	var last = get_last_move()
	if last:
		return last.destination_position
	return Vector2i.ZERO


## Check if this action contains any attacks
func has_attack() -> bool:
	for move in moves:
		if move.is_attack():
			return true
	return false
