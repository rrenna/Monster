## Effect - Represents stat modifications from skills
## Ported from MEffect.h/mm
class_name Effect
extends Resource

@export var damage: float = 0.0
@export var health: float = 0.0
@export var energy: float = 0.0
@export var moves: int = 0
@export var target_type: int = Enums.EffectTargetType.ENEMY  # Enums.EffectTargetType


## Create a damage-only effect
static func create_damage(p_damage: float) -> Effect:
	var effect = Effect.new()
	effect.damage = p_damage
	return effect


## Create a healing effect
static func create_health(p_health: float) -> Effect:
	var effect = Effect.new()
	effect.health = p_health
	return effect


## Create an energy restoration effect
static func create_energy(p_energy: float) -> Effect:
	var effect = Effect.new()
	effect.energy = p_energy
	return effect


## Create a move restoration effect
static func create_moves(p_moves: int) -> Effect:
	var effect = Effect.new()
	effect.moves = p_moves
	return effect


## Create a full effect with all properties
static func create_full(p_damage: float, p_health: float, p_energy: float, p_moves: int) -> Effect:
	var effect = Effect.new()
	effect.damage = p_damage
	effect.health = p_health
	effect.energy = p_energy
	effect.moves = p_moves
	return effect
