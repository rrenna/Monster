## AStarSearch - A* pathfinding algorithm for unit movement
## Ported from MAStarSearch.h/mm
class_name AStarSearch
extends RefCounted


## Internal node class for A* algorithm
class AStarNode:
	var location: Vector2i
	var cost_from_start: float = 0.0
	var cost_from_goal: float = 0.0
	var depth: int = 0
	var parent: AStarNode = null

	func get_total_cost() -> float:
		return cost_from_start + cost_from_goal

	func compare_to(other: AStarNode) -> int:
		var my_cost = get_total_cost()
		var other_cost = other.get_total_cost()
		if my_cost < other_cost:
			return -1
		elif my_cost > other_cost:
			return 1
		return 0


var _map: GameMap
var _goal: Vector2i
var _move_skill: Skill
var _final_skill: Skill
var _friendly_team: Team


func _init(map: GameMap) -> void:
	_map = map


## Main A* search algorithm
## Returns an Action containing the path, or null if no path found
func find_path(
	start: Vector2i,
	goal: Vector2i,
	move_limit: int,
	move_skill: Skill,
	final_skill: Skill,
	friendly_team: Team
) -> Action:
	_goal = goal
	_move_skill = move_skill
	_final_skill = final_skill
	_friendly_team = friendly_team

	# Priority queue (using array with manual sorting)
	var open: Array[AStarNode] = []
	var closed: Array[AStarNode] = []

	# Create start node
	var start_node = AStarNode.new()
	start_node.location = start
	start_node.cost_from_start = 0
	start_node.cost_from_goal = _path_cost_estimate(start, goal)
	start_node.depth = 0

	open.append(start_node)

	while open.size() > 0:
		# Sort and get lowest cost node
		open.sort_custom(func(a, b): return a.get_total_cost() < b.get_total_cost())
		var current = open.pop_front()

		# Check if we reached the goal
		if current.location == goal:
			return _get_action_from_node(current)

		closed.append(current)

		# Get neighbors
		for neighbor_node in _get_neighbors(current):
			var new_cost = current.cost_from_start + _traverse_cost(current, neighbor_node)

			# Check if neighbor is in open or closed
			var in_open = _find_node_in_list(open, neighbor_node.location)
			var in_closed = _find_node_in_list(closed, neighbor_node.location)

			# Skip if already processed with lower cost
			if (in_open != null or in_closed != null) and neighbor_node.cost_from_start <= new_cost:
				continue

			# Check depth limit
			if current.depth + 1 > move_limit:
				continue

			# Update node
			neighbor_node.parent = current
			neighbor_node.cost_from_start = new_cost
			neighbor_node.cost_from_goal = _path_cost_estimate(neighbor_node.location, goal)
			neighbor_node.depth = current.depth + 1

			# Remove from closed if present
			if in_closed != null:
				closed.erase(in_closed)

			# Add to open (or update if already present)
			if in_open != null:
				open.erase(in_open)
			open.append(neighbor_node)

	# No path found
	return null


## Heuristic distance estimate (Manhattan/Euclidean)
func _path_cost_estimate(start: Vector2i, goal: Vector2i) -> float:
	return start.distance_to(goal)


## Cost to traverse from one node to another
func _traverse_cost(_from_node: AStarNode, _to_node: AStarNode) -> float:
	# Could add terrain modifiers here
	return 1.0


## Get valid neighbor nodes
func _get_neighbors(node: AStarNode) -> Array[AStarNode]:
	var neighbors: Array[AStarNode] = []

	var directions = [
		Vector2i(0, 1),   # North
		Vector2i(1, 0),   # East
		Vector2i(-1, 0),  # West
		Vector2i(0, -1),  # South
	]

	for dir in directions:
		var pos = node.location + dir
		if _is_direction_valid(pos):
			var neighbor = AStarNode.new()
			neighbor.location = pos
			neighbors.append(neighbor)

	return neighbors


## Check if a direction/position is valid for pathfinding
func _is_direction_valid(pos: Vector2i) -> bool:
	if not _map.is_valid_position(pos):
		return false

	# Check if this is the goal position
	if pos == _goal:
		if _final_skill.is_movement():
			# Movement skill - must be walkable and empty
			if not _map.is_walkable(pos):
				return false
			if EntityManager.get_unit_team_at(pos) != null:
				return false
			return true
		elif _final_skill.is_attack():
			# Attack skill - must have enemy unit
			var team_at_pos = EntityManager.get_unit_team_at(pos)
			return team_at_pos != null and team_at_pos != _friendly_team
	else:
		# Not the goal - must be walkable and empty
		if not _map.is_walkable(pos):
			return false
		if EntityManager.get_unit_team_at(pos) != null:
			return false
		return true

	return false


## Find a node in a list by location
func _find_node_in_list(list: Array, location: Vector2i) -> AStarNode:
	for node in list:
		if node.location == location:
			return node
	return null


## Construct an Action from the found path
func _get_action_from_node(node: AStarNode) -> Action:
	var moves: Array[Move] = []
	var current = node
	var is_first = true

	while current.parent != null:
		var skill = _final_skill if is_first else _move_skill
		var move = Move.new(current.parent.location, current.location, skill)
		moves.insert(0, move)
		is_first = false
		current = current.parent

	return Action.create_multi(moves)
