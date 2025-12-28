## GameMap - Level/arena definition with grid system
## Ported from MMap.h/mm
class_name GameMap
extends Node2D

@export var map_width: int = 12
@export var map_height: int = 12

# Grids for different layers
var sky_grid: Array = []  # 2D array [x][y]
var structure_grid: Array = []  # 2D array [x][y]

@onready var tile_map: TileMapLayer = $TileMapLayer if has_node("TileMapLayer") else null


func _ready() -> void:
	_initialize_grids()


## Initialize empty grids
func _initialize_grids() -> void:
	sky_grid = []
	structure_grid = []

	for x in range(map_width):
		sky_grid.append([])
		structure_grid.append([])
		for y in range(map_height):
			sky_grid[x].append(0)
			structure_grid[x].append(0)


## Check if a position is within map bounds
func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < map_width and pos.y >= 0 and pos.y < map_height


## Check if a position is walkable
func is_walkable(pos: Vector2i) -> bool:
	if not is_valid_position(pos):
		return false

	# Check structure grid for obstacles
	if structure_grid[pos.x][pos.y] != 0:
		return false

	# Check if there's a structure entity at this position
	var structure = EntityManager.get_structure_at(pos)
	if structure and not structure.crushable:
		return false

	return true


## Get tile data at a position
func get_tile_at(pos: Vector2i) -> int:
	if not is_valid_position(pos):
		return -1
	return sky_grid[pos.x][pos.y]


## Set tile data at a position
func set_tile_at(pos: Vector2i, value: int) -> void:
	if is_valid_position(pos):
		sky_grid[pos.x][pos.y] = value


## Get structure value at a position
func get_structure_at(pos: Vector2i) -> int:
	if not is_valid_position(pos):
		return -1
	return structure_grid[pos.x][pos.y]


## Set structure value at a position
func set_structure_at(pos: Vector2i, value: int) -> void:
	if is_valid_position(pos):
		structure_grid[pos.x][pos.y] = value


## Load map from a TMX file or resource
func load_from_resource(resource_path: String) -> void:
	# Would load tile data from a TileMap resource
	pass


## Get all walkable neighbors of a position
func get_walkable_neighbors(pos: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	var directions = [
		Vector2i(0, -1),  # Up
		Vector2i(1, 0),   # Right
		Vector2i(0, 1),   # Down
		Vector2i(-1, 0),  # Left
	]

	for dir in directions:
		var neighbor = pos + dir
		if is_walkable(neighbor):
			neighbors.append(neighbor)

	return neighbors


## Get all neighbors of a position (including non-walkable)
func get_all_neighbors(pos: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	var directions = [
		Vector2i(0, -1),
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 0),
	]

	for dir in directions:
		var neighbor = pos + dir
		if is_valid_position(neighbor):
			neighbors.append(neighbor)

	return neighbors


## Convert grid position to world position
func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return GameSettings.grid_to_world(grid_pos)


## Convert world position to grid position
func world_to_grid(world_pos: Vector2) -> Vector2i:
	return GameSettings.world_to_grid(world_pos)
