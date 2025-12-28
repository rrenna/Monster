## Match - Game/match state manager
## Ported from MMatch.h/mm
class_name Match
extends Node

signal round_changed(new_round: int)
signal turn_changed(team: Team)
signal match_state_changed(state: int)
signal control_state_changed(state: int)

@export var max_rounds: int = 10

var round: int = 0
var turn_complete: bool = false
var match_state: int = Enums.MatchState.IN_PROGRESS
var control_state: int = Enums.ControlState.NONE
var current_team: Team = null
var teams: Array[Team] = []
var team_turn_queue: Array[Team] = []
var map: GameMap = null


func _init(p_max_rounds: int = 10, p_teams: Array[Team] = []) -> void:
	max_rounds = p_max_rounds
	for team in p_teams:
		add_team(team)


## Add a team to the match
func add_team(team: Team) -> void:
	teams.append(team)
	push_team(team)


## Push a team onto the turn queue
func push_team(team: Team) -> void:
	team_turn_queue.insert(0, team)


## Pop a team from the turn queue
func pop_team() -> Team:
	if team_turn_queue.is_empty():
		return null
	return team_turn_queue.pop_back()


## Check if there are queued teams
func has_queued_team() -> bool:
	return not team_turn_queue.is_empty()


## Complete the current turn
func complete_turn() -> void:
	turn_complete = true
	next_turn()


## Begin the match
func begin() -> void:
	round = 1
	turn_complete = false
	match_state = Enums.MatchState.IN_PROGRESS
	control_state = Enums.ControlState.NONE

	match_state_changed.emit(match_state)
	round_changed.emit(round)

	# Start first turn
	next_turn()


## Move to the next turn
func next_turn() -> void:
	if has_queued_team():
		_next_team()
	else:
		next_round()


## Move to the next team's turn
func _next_team() -> void:
	current_team = pop_team()
	turn_complete = false

	# Set control state based on team type
	if current_team.is_player_controlled:
		control_state = Enums.ControlState.PLAYER
	else:
		control_state = Enums.ControlState.CPU

	control_state_changed.emit(control_state)
	turn_changed.emit(current_team)

	# Replenish moves for all units on this team
	_replenish_team_moves(current_team)


## Replenish moves for all units on a team
func _replenish_team_moves(team: Team) -> void:
	for unit in EntityManager.get_all_units():
		if unit is Unit and unit.team == team:
			unit.replenish_moves()


## Move to the next round
func next_round() -> void:
	control_state = Enums.ControlState.NONE
	control_state_changed.emit(control_state)

	if match_state == Enums.MatchState.IN_PROGRESS:
		if round < max_rounds:
			round += 1
			round_changed.emit(round)

			# Queue up all teams for the new round
			for team in teams:
				push_team(team)

			# Start the first turn of the new round
			next_turn()
		else:
			# Match is over
			match_state = Enums.MatchState.COMPLETED
			match_state_changed.emit(match_state)


## Check if the match is in progress
func is_in_progress() -> bool:
	return match_state == Enums.MatchState.IN_PROGRESS


## Check if it's the player's turn
func is_player_turn() -> bool:
	return control_state == Enums.ControlState.PLAYER


## Check if it's the CPU's turn
func is_cpu_turn() -> bool:
	return control_state == Enums.ControlState.CPU


## Get the winner (if match is completed)
func get_winner() -> Team:
	if match_state != Enums.MatchState.COMPLETED:
		return null

	# Determine winner based on remaining units
	for team in teams:
		if team.has_units_remaining():
			return team

	return null
