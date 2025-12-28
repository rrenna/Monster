## SkillChest - Container for a unit's available skills
## Ported from MSkillChest.h/mm
class_name SkillChest
extends Resource

@export var skills: Array[Skill] = []


## Add a skill to the chest
func add_skill(skill: Skill) -> void:
	skills.append(skill)


## Get a skill by name
func get_skill(skill_name: String) -> Skill:
	for skill in skills:
		if skill.skill_name == skill_name:
			return skill
	return null


## Get all attack skills
func get_attack_skills() -> Array[Skill]:
	var attack_skills: Array[Skill] = []
	for skill in skills:
		if skill.is_attack():
			attack_skills.append(skill)
	return attack_skills


## Get all movement skills
func get_movement_skills() -> Array[Skill]:
	var movement_skills: Array[Skill] = []
	for skill in skills:
		if skill.is_movement():
			movement_skills.append(skill)
	return movement_skills


## Get the primary movement skill (first one found)
func get_primary_movement_skill() -> Skill:
	for skill in skills:
		if skill.is_movement():
			return skill
	return null


## Get the primary attack skill (first one found)
func get_primary_attack_skill() -> Skill:
	for skill in skills:
		if skill.is_attack():
			return skill
	return null
