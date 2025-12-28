## Unit - Playable/AI controlled character
## Ported from MUnit.h/mm
class_name Unit
extends Entity

signal moves_changed(new_moves: int)
signal action_completed()

@export var persona_name: String = ""

var moves: int = 0
var has_queued_moves: bool = false
var next_action: Action = null
var persona: Persona = null

# Particle scenes for damage effects
var blood_particle_scene: PackedScene = null
var spark_particle_scene: PackedScene = null


func _ready() -> void:
	super._ready()
	_load_persona()
	replenish_moves()


## Load persona from registry
func _load_persona() -> void:
	if persona_name != "":
		persona = Persona.get_persona(persona_name)
		if persona:
			max_health = 100.0  # Could be defined in persona
			_update_animation()


## Initialize unit with name, position, team
func initialize(p_name: String, p_position: Vector2i, p_team: Team) -> void:
	entity_name = p_name
	persona_name = p_name
	super.initialize(p_name, p_position, p_team)
	_load_persona()
	replenish_moves()


## Get all available actions for this unit on the given map
func get_actions(map: GameMap) -> Array[Action]:
	var actions: Array[Action] = []
	var speed = moves

	if not persona or not persona.skill_chest:
		return actions

	var movement_skills = persona.skill_chest.get_movement_skills()
	var attack_skills = persona.skill_chest.get_attack_skills()

	# Generate movement and melee attack actions
	for movement_skill in movement_skills:
		if moves >= movement_skill.move_cost:
			# Check positions in a diamond pattern based on movement range
			var skip_amount = speed
			var direction_switch = true

			for y in range(speed, -speed - 1, -1):
				for x in range(-speed, speed + 1):
					var pos = Vector2i(grid_position.x + x, grid_position.y + y)

					if not map.is_valid_position(pos):
						continue

					var team_at_pos = EntityManager.get_unit_team_at(pos)

					# Current position - check defensive skills
					if y == 0 and x == 0:
						continue

					# Skip unwalkable positions
					if not map.is_walkable(pos):
						continue

					# Position has an enemy unit - generate attack actions
					if team_at_pos != null and team_at_pos != team:
						for attack_skill in attack_skills:
							if attack_skill.attack_range == 1:  # Melee
								var astar = AStarSearch.new(map)
								var action = astar.find_path(
									grid_position, pos, speed,
									movement_skill, attack_skill, team
								)
								if action:
									actions.append(action)

					# Empty walkable position - generate movement action
					elif team_at_pos == null:
						if x >= (-speed + skip_amount) and x <= (speed - skip_amount):
							var astar = AStarSearch.new(map)
							var action = astar.find_path(
								grid_position, pos, speed,
								movement_skill, movement_skill, team
							)
							if action:
								actions.append(action)

				# Diamond pattern logic
				if y == 0:
					direction_switch = not direction_switch
				if direction_switch:
					skip_amount -= 1
				else:
					skip_amount += 1

	# Generate ranged attack actions
	for attack_skill in attack_skills:
		if attack_skill.attack_range > 1:
			var all_units = EntityManager.get_all_units()
			for unit in all_units:
				if unit.team == team:
					continue
				var distance = grid_position.distance_to(unit.grid_position)
				if distance <= attack_skill.attack_range:
					var ranged_move = Move.new(grid_position, unit.grid_position, attack_skill)
					var ranged_action = Action.create_single(ranged_move)
					actions.append(ranged_action)

	return actions


## Perform the queued action
func perform_queued_action() -> void:
	if next_action:
		perform_action(next_action)


## Perform an action (sequence of moves)
func perform_action(action: Action) -> void:
	if action.moves.size() > 0:
		has_queued_moves = true
		var move = action.moves[0]
		perform_move(move)
		action.moves.remove_at(0)

		# Queue remaining moves
		if action.moves.size() > 0:
			next_action = action
		else:
			has_queued_moves = false
			next_action = null
			action_completed.emit()
	else:
		has_queued_moves = false
		action_completed.emit()


## Perform a single move
func perform_move(move: Move) -> void:
	moves -= 1
	moves_changed.emit(moves)

	if move.skill == null:
		_perform_movement(move)
	elif move.skill.is_movement():
		_perform_movement(move)
	elif move.skill.is_attack():
		if move.skill.attack_range == 1:
			_perform_melee_attack(move)
		else:
			_perform_range_attack(move)


## Perform movement to a new position
func _perform_movement(move: Move) -> void:
	set_activity_state(Enums.ActivityState.ROTATING)

	var delta = move.destination_position - grid_position
	var new_angle = atan2(-delta.y, delta.x) + PI / 2

	# Update grid position in entity manager
	EntityManager.refresh_entity_key(self, Enums.EntityType.UNIT, move.destination_position)
	grid_position = move.destination_position

	# Calculate rotation time based on weight
	var angle_diff = abs(new_angle - rotation)
	var rotation_time = (angle_diff / TAU) * (0.45 * persona.weight) if persona else 0.3

	# Create rotation tween
	var tween = create_tween()
	tween.tween_property(self, "rotation", new_angle, rotation_time)

	# After rotation, move to new position
	tween.tween_callback(func():
		set_activity_state(Enums.ActivityState.MOVING)
	)

	var target_pos = GameSettings.grid_to_world(move.destination_position)
	tween.tween_property(self, "position", target_pos, 0.5)

	# Return to idle after movement
	tween.tween_callback(func():
		set_activity_state(Enums.ActivityState.IDLE)
		if has_queued_moves and next_action:
			perform_action(next_action)
	)


## Perform melee attack
func _perform_melee_attack(move: Move) -> void:
	set_activity_state(Enums.ActivityState.MELEE)

	var delta = move.destination_position - grid_position
	var new_angle = atan2(-delta.y, delta.x) + PI / 2

	var angle_diff = abs(new_angle - rotation)
	var rotation_time = (angle_diff / TAU) * (0.5 * persona.weight) if persona else 0.3

	var tween = create_tween()
	tween.tween_property(self, "rotation", new_angle, rotation_time)

	# Deal damage after rotation
	tween.tween_callback(func():
		var damage_msg = MessageBus.Message.new(
			entity_name,
			GameSettings.position_key(move.destination_position),
			Enums.EntityType.UNIT,
			Enums.MessageType.DAMAGE,
			{"damage": 50.0, "force": Vector2(delta.x, delta.y).normalized() * 5}
		)
		MessageBus.send_message(damage_msg)
	)

	# Return to idle
	tween.tween_callback(func():
		set_activity_state(Enums.ActivityState.IDLE)
		if has_queued_moves and next_action:
			perform_action(next_action)
	).set_delay(0.2)


## Perform ranged attack
func _perform_range_attack(move: Move) -> void:
	set_activity_state(Enums.ActivityState.ROTATING)

	var delta = move.destination_position - grid_position
	var new_angle = atan2(-delta.y, delta.x) + PI / 2

	var angle_diff = abs(new_angle - rotation)
	var rotation_time = (angle_diff / TAU) * (0.5 * persona.weight) if persona else 0.3

	var tween = create_tween()
	tween.tween_property(self, "rotation", new_angle, rotation_time)

	# Fire projectile after rotation
	tween.tween_callback(func():
		_fire_projectile(move)
	)


## Fire a projectile
func _fire_projectile(move: Move) -> void:
	set_activity_state(Enums.ActivityState.RANGE)

	var delta = move.destination_position - grid_position
	var force = Vector2(delta.x, delta.y).normalized() * 10

	# Shake effect
	perform_shake_with_force(force * 0.1)

	# Calculate shot origin with range offset
	var shot_pos = position
	if persona:
		var rad_angle = rotation
		var offset = persona.range_offset
		shot_pos.x += offset.x * cos(-rad_angle) - offset.y * sin(-rad_angle)
		shot_pos.y += offset.x * sin(-rad_angle) + offset.y * cos(-rad_angle)

	# Spawn projectile
	EntityManager.spawn_projectile(shot_pos, force, 10.0, team)

	# Return to idle after delay
	var tween = create_tween()
	tween.tween_callback(func():
		set_activity_state(Enums.ActivityState.IDLE)
		if has_queued_moves and next_action:
			perform_action(next_action)
	).set_delay(0.5)


## Queue an action for later execution
func queue_action(action: Action) -> void:
	has_queued_moves = true
	next_action = action


## Replenish moves at start of turn
func replenish_moves() -> void:
	if persona:
		moves = persona.max_moves
	else:
		moves = 3
	moves_changed.emit(moves)


## Override update
func update() -> void:
	super.update()
	# If no actions running, return to idle
	if activity_state != Enums.ActivityState.IDLE:
		# Check if any tweens are running
		pass
	_update_animation()


## Update animation based on activity state
func _update_animation() -> void:
	if not persona:
		return

	# Get animation name from persona
	var anim_name = persona.get_animation_for_state(activity_state)
	# Animation would be applied here via AnimatedSprite2D or AnimationPlayer


## Apply damage with particle effects
func perform_damage(damage: float, force: Vector2 = Vector2.ZERO) -> void:
	super.perform_damage(damage, force)

	# Spawn particle effect based on sentience type
	if persona:
		var particle_file = ""
		if persona.sentience_type == Enums.SentienceType.ORGANIC:
			particle_file = "blood_spurt"
		else:
			particle_file = "spark"
		# Would spawn particles here


## Kill this unit
func kill() -> void:
	if not is_queued_for_deletion():
		EntityManager.remove_entity(self, Enums.EntityType.UNIT, true)
		queue_free()
