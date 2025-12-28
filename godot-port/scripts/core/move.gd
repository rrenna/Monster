## Move - Represents a single movement or attack action
## Ported from MMove.h/mm
class_name Move
extends RefCounted

var source_position: Vector2i
var destination_position: Vector2i
var skill: Skill
var move_type: int  # Enums.MoveType


func _init(
	p_source: Vector2i = Vector2i.ZERO,
	p_destination: Vector2i = Vector2i.ZERO,
	p_skill: Skill = null
) -> void:
	source_position = p_source
	destination_position = p_destination
	skill = p_skill
	_determine_move_type()


## Determine the move type based on the skill
func _determine_move_type() -> void:
	if skill == null:
		move_type = Enums.MoveType.MOVEMENT
	elif skill.is_movement():
		move_type = Enums.MoveType.MOVEMENT
	elif skill.is_attack():
		# Check if it's ranged or melee based on range
		if skill.attack_range > 1:
			move_type = Enums.MoveType.RANGED_ATTACK
		else:
			move_type = Enums.MoveType.MELEE_ATTACK
	elif skill.is_defensive():
		move_type = Enums.MoveType.DEFENSIVE
	else:
		move_type = Enums.MoveType.MOVEMENT


## Get the direction vector of this move
func get_direction() -> Vector2i:
	return destination_position - source_position


## Get the distance of this move
func get_distance() -> float:
	return source_position.distance_to(destination_position)


## Check if this is an attack move
func is_attack() -> bool:
	return move_type == Enums.MoveType.MELEE_ATTACK or move_type == Enums.MoveType.RANGED_ATTACK


## Check if this is a movement move
func is_movement() -> bool:
	return move_type == Enums.MoveType.MOVEMENT
