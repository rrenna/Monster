## GameUI - In-game UI controller
extends Control

@onready var round_label: Label = $TopBar/RoundLabel
@onready var turn_label: Label = $TopBar/TurnLabel
@onready var end_turn_button: Button = $EndTurnButton

var current_match: Match = null


func _ready() -> void:
	end_turn_button.pressed.connect(_on_end_turn_pressed)

	# Find or create the match
	_setup_match()


func _setup_match() -> void:
	# Create teams
	var player_team = Team.new(Color.BLUE, true)
	var enemy_team = Team.new(Color.RED, false)

	# Create match
	current_match = Match.new(10, [player_team, enemy_team])

	# Connect signals
	current_match.round_changed.connect(_on_round_changed)
	current_match.turn_changed.connect(_on_turn_changed)
	current_match.match_state_changed.connect(_on_match_state_changed)

	# Start the match
	current_match.begin()


func _on_round_changed(new_round: int) -> void:
	round_label.text = "Round: %d" % new_round


func _on_turn_changed(team: Team) -> void:
	if team.is_player_controlled:
		turn_label.text = "Turn: Player"
		end_turn_button.disabled = false
	else:
		turn_label.text = "Turn: Enemy"
		end_turn_button.disabled = true
		# Trigger AI turn
		_do_ai_turn()


func _on_match_state_changed(state: int) -> void:
	if state == Enums.MatchState.COMPLETED:
		turn_label.text = "Match Over!"
		end_turn_button.disabled = true


func _on_end_turn_pressed() -> void:
	if current_match:
		current_match.complete_turn()


func _do_ai_turn() -> void:
	# Simple AI: just end turn after a delay
	await get_tree().create_timer(1.0).timeout
	if current_match and current_match.is_cpu_turn():
		current_match.complete_turn()
