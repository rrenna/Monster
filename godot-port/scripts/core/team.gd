## Team - Represents a team of units
## Ported from MTeam.h/mm
class_name Team
extends RefCounted

var color: Color
var main_entity: Node2D  # Reference to the main entity (e.g., base or leader)
var is_player_controlled: bool


func _init(p_color: Color = Color.WHITE, p_controlled: bool = false) -> void:
	color = p_color
	is_player_controlled = p_controlled


## Set the main entity for this team
func set_main_entity(entity: Node2D) -> void:
	main_entity = entity


## Check if this team is controlled by a player
func is_controlled() -> bool:
	return is_player_controlled


## Get all units belonging to this team
func get_units() -> Array:
	var units: Array = []
	var all_units = EntityManager.get_all_units()
	for unit in all_units:
		if unit.team == self:
			units.append(unit)
	return units


## Check if this team has any units remaining
func has_units_remaining() -> bool:
	return not get_units().is_empty()


## Get a unit that hasn't moved yet this turn
func get_unmoved_unit() -> Node2D:
	for unit in get_units():
		if unit.moves > 0:
			return unit
	return null
