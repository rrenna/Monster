## Skill - Represents a unit ability
## Ported from MSkill.h/mm
class_name Skill
extends Resource

@export var skill_name: String = ""
@export var skill_type: int = Enums.SkillType.ATTACK  # Enums.SkillType
@export var energy_cost: float = 0.0
@export var move_cost: int = 1
@export var attack_range: int = 1
@export var accuracy: float = 1.0
@export var effects: Array[Effect] = []
@export var augments: Array[Skill] = []


func _init(
	p_name: String = "",
	p_type: int = Enums.SkillType.ATTACK,
	p_energy_cost: float = 0.0,
	p_move_cost: int = 1,
	p_range: int = 1,
	p_accuracy: float = 1.0
) -> void:
	skill_name = p_name
	skill_type = p_type
	energy_cost = p_energy_cost
	move_cost = p_move_cost
	attack_range = p_range
	accuracy = p_accuracy


## Add an effect to this skill
func add_effect(effect: Effect) -> void:
	effects.append(effect)


## Add multiple effects to this skill
func set_effects(p_effects: Array[Effect]) -> void:
	effects = p_effects


## Check if this is an attack skill
func is_attack() -> bool:
	return skill_type == Enums.SkillType.ATTACK


## Check if this is a movement skill
func is_movement() -> bool:
	return skill_type == Enums.SkillType.MOVEMENT


## Check if this is a defensive skill
func is_defensive() -> bool:
	return skill_type == Enums.SkillType.DEFENSE


## Calculate total damage from all effects
func get_total_damage() -> float:
	var total: float = 0.0
	for effect in effects:
		total += effect.damage
	return total
