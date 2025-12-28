## EntityManager - Global entity lifecycle and physics management
## Ported from MEntityManager.h/mm
extends Node

signal entity_added(entity: Node2D, type: int)
signal entity_removed(entity: Node2D, type: int)
signal focus_changed(entity: Node2D)

# Entity dictionaries keyed by position string
var _units: Dictionary = {}  # position_key -> Unit
var _structures: Dictionary = {}  # position_key -> Structure
var _projectiles: Array = []

# Focus tracking
var _focus_entity: Node2D = null

# Cleanup queue
var _cleanup_queue: Array = []

# Processing flag
var _is_processing: bool = false

# Reference to the game layer for spawning entities
var _game_layer: Node2D = null

# Projectile scene for spawning
var _projectile_scene: PackedScene = null


func _ready() -> void:
	# Connect to message bus for entity-targeted messages
	MessageBus.message_sent.connect(_on_message_received)


func _process(_delta: float) -> void:
	_process_cleanup_queue()


## Initialize with the game layer
func init_with_layer(layer: Node2D) -> void:
	_game_layer = layer


## Check if currently processing
func is_processing() -> bool:
	return _is_processing


## Add an entity to the manager
func add_entity(entity: Node2D, type: int) -> void:
	var key = ""

	if entity is Entity:
		key = GameSettings.position_key(entity.grid_position)

	match type:
		Enums.EntityType.UNIT:
			_units[key] = entity
		Enums.EntityType.STRUCTURE:
			_structures[key] = entity

	entity_added.emit(entity, type)


## Remove an entity from the manager
func remove_entity(entity: Node2D, type: int, cleanup: bool = false) -> void:
	var key = ""

	if entity is Entity:
		key = GameSettings.position_key(entity.grid_position)

	match type:
		Enums.EntityType.UNIT:
			_units.erase(key)
		Enums.EntityType.STRUCTURE:
			_structures.erase(key)

	if cleanup:
		_cleanup_queue.append(entity)

	entity_removed.emit(entity, type)


## Refresh entity key when it moves
func refresh_entity_key(entity: Node2D, type: int, new_position: Vector2i) -> void:
	if not entity is Entity:
		return

	var old_key = GameSettings.position_key(entity.grid_position)
	var new_key = GameSettings.position_key(new_position)

	match type:
		Enums.EntityType.UNIT:
			if _units.has(old_key):
				_units.erase(old_key)
			_units[new_key] = entity
		Enums.EntityType.STRUCTURE:
			if _structures.has(old_key):
				_structures.erase(old_key)
			_structures[new_key] = entity


## Set the focus entity
func set_focus_entity(entity: Node2D) -> void:
	_focus_entity = entity
	focus_changed.emit(entity)


## Get the focus entity
func get_focus_entity() -> Node2D:
	return _focus_entity


## Clear the focus entity
func clear_focus_entity() -> void:
	_focus_entity = null
	focus_changed.emit(null)


## Get all units dictionary
func get_all_units_dict() -> Dictionary:
	return _units


## Get all units as array
func get_all_units() -> Array:
	return _units.values()


## Get all structures dictionary
func get_all_structures_dict() -> Dictionary:
	return _structures


## Get all structures as array
func get_all_structures() -> Array:
	return _structures.values()


## Get unit at a specific position
func get_unit_at(pos: Vector2i) -> Node2D:
	var key = GameSettings.position_key(pos)
	if _units.has(key):
		return _units[key]
	return null


## Get structure at a specific position
func get_structure_at(pos: Vector2i) -> Node2D:
	var key = GameSettings.position_key(pos)
	if _structures.has(key):
		return _structures[key]
	return null


## Get team of unit at position
func get_unit_team_at(pos: Vector2i) -> Team:
	var unit = get_unit_at(pos)
	if unit and unit is Entity:
		return unit.team
	return null


## Get an unmoved unit for a team
func get_unmoved_unit(team: Team) -> Node2D:
	for unit in _units.values():
		if unit is Unit and unit.team == team and unit.moves > 0:
			return unit
	return null


## Get entity by name
func get_entity_by_name(entity_name: String) -> Node2D:
	# First check if it's a position key
	if _units.has(entity_name):
		return _units[entity_name]
	if _structures.has(entity_name):
		return _structures[entity_name]

	# Otherwise search by entity_name property
	for unit in _units.values():
		if unit is Entity and unit.entity_name == entity_name:
			return unit
	for structure in _structures.values():
		if structure is Entity and structure.entity_name == entity_name:
			return structure

	return null


## Spawn a projectile
func spawn_projectile(pos: Vector2, force: Vector2, damage: float, team: Team) -> Projectile:
	var projectile: Projectile = null

	if _projectile_scene:
		projectile = _projectile_scene.instantiate() as Projectile
	else:
		# Create a basic projectile node
		projectile = Projectile.new()

	if projectile:
		projectile.initialize(pos, force, damage, team)
		_projectiles.append(projectile)

		if _game_layer:
			_game_layer.add_child(projectile)

	return projectile


## Remove a projectile
func remove_projectile(projectile: Projectile) -> void:
	_projectiles.erase(projectile)


## Process the cleanup queue
func _process_cleanup_queue() -> void:
	for entity in _cleanup_queue:
		if is_instance_valid(entity) and not entity.is_queued_for_deletion():
			entity.queue_free()
	_cleanup_queue.clear()


## Handle messages from message bus
func _on_message_received(message: MessageBus.Message) -> void:
	# Route messages to appropriate entities based on receiver
	if message.receiver == "":
		return

	# Check if receiver is a position key
	var entity = get_entity_by_name(message.receiver)
	if entity and entity.has_method("receive_message"):
		entity.receive_message(message)


## Clear all entities
func clear_all() -> void:
	for unit in _units.values():
		if is_instance_valid(unit):
			unit.queue_free()
	for structure in _structures.values():
		if is_instance_valid(structure):
			structure.queue_free()
	for projectile in _projectiles:
		if is_instance_valid(projectile):
			projectile.queue_free()

	_units.clear()
	_structures.clear()
	_projectiles.clear()
	_focus_entity = null
