## GameSettings - Global game configuration
## Ported from MSettings.h/mm
extends Node

# Map Settings
const TILE_X_SIZE: int = 64
const TILE_Y_SIZE: int = 64
const MAP_X_SIZE: int = 12
const MAP_Y_SIZE: int = 12

# Interface Settings
const FINGER_SCROLL_MULTIPLIER: float = 1.5
const MIN_SCROLL_SPEED: int = 100
const MAX_SCROLL_SPEED: int = 500
const SELECTION_PIXEL_PRECISION: int = 32

# Entity Settings
const MAX_PROJECTILES: int = 10

# Physics Settings (from Box2D PTM_RATIO)
const PIXELS_TO_METERS: float = 32.0

# Game framerate
const TARGET_FPS: int = 30


## Convert grid position to world position
static func grid_to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * TILE_X_SIZE + TILE_X_SIZE / 2,
		grid_pos.y * TILE_Y_SIZE + TILE_Y_SIZE / 2
	)


## Convert world position to grid position
static func world_to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		int(world_pos.x / TILE_X_SIZE),
		int(world_pos.y / TILE_Y_SIZE)
	)


## Check if a grid position is within map bounds
static func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < MAP_X_SIZE and pos.y >= 0 and pos.y < MAP_Y_SIZE


## Generate a unique key for a grid position (for dictionary lookups)
static func position_key(pos: Vector2i) -> String:
	return "%d,%d" % [pos.x, pos.y]
