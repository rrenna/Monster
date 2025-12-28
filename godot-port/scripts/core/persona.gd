## Persona - Character template/archetype for units
## Ported from MPersona.h/mm
class_name Persona
extends Resource

@export var persona_name: String = ""
@export var sprite_name: String = ""
@export var sentience_type: int = Enums.SentienceType.ORGANIC  # Enums.SentienceType
@export var max_moves: int = 3
@export var weight: float = 1.0
@export var range_offset: Vector2i = Vector2i.ZERO
@export var skill_chest: SkillChest

# Animation dictionary mapping activity states to sprite frame names
@export var animations: Dictionary = {}

# Collision shape size for physics
@export var collision_size: Vector2 = Vector2(32, 32)

# Static registry of all personas
static var _persona_registry: Dictionary = {}


func _init(
	p_name: String = "",
	p_sprite_name: String = "",
	p_sentience: int = Enums.SentienceType.ORGANIC,
	p_max_moves: int = 3,
	p_weight: float = 1.0,
	p_range_offset: Vector2i = Vector2i.ZERO,
	p_animations: Dictionary = {}
) -> void:
	persona_name = p_name
	sprite_name = p_sprite_name
	sentience_type = p_sentience
	max_moves = p_max_moves
	weight = p_weight
	range_offset = p_range_offset
	animations = p_animations


## Register a persona in the static registry
static func register_persona(persona: Persona) -> void:
	_persona_registry[persona.persona_name] = persona


## Get a persona by name from the registry
static func get_persona(name: String) -> Persona:
	if _persona_registry.has(name):
		return _persona_registry[name]
	return null


## Get animation frames for a given activity state
func get_animation_for_state(state: int) -> String:
	var state_name = _activity_state_to_string(state)
	if animations.has(state_name):
		return animations[state_name]
	return sprite_name  # Fallback to base sprite


## Convert activity state enum to string key
func _activity_state_to_string(state: int) -> String:
	match state:
		Enums.ActivityState.IDLE:
			return "idle"
		Enums.ActivityState.MELEE:
			return "melee"
		Enums.ActivityState.MOVING:
			return "moving"
		Enums.ActivityState.ROTATING:
			return "rotating"
		Enums.ActivityState.RANGE:
			return "range"
		_:
			return "idle"
