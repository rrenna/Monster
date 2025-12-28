## Enums - Global enumerations for Monster game
## Ported from iOS Objective-C to Godot 4.5
extends Node

# Activity states for entities (from MEntity.h)
enum ActivityState {
	IDLE,
	MELEE,
	MOVING,
	ROTATING,
	RANGE
}

# Message types for inter-entity communication (from MMessage.h)
enum MessageType {
	UPDATE,
	TRANSFORMATION,
	FIRE_PROJECTILE,
	DAMAGE,
	SPRITE_CHANGE,
	ACTIVITY_STATE_CHANGE
}

# Entity types (from MMessage.h)
enum EntityType {
	UNIT,
	STRUCTURE,
	ANY
}

# Skill types (from MSkill.h)
enum SkillType {
	ATTACK,
	DEFENSE,
	MOVEMENT,
	PASSIVE
}

# Effect target types (from MEffect.h)
enum EffectTargetType {
	SELF,
	TEAM,
	ENEMY,
	ALL
}

# Move types (from MMove.h)
enum MoveType {
	MOVEMENT,
	MELEE_ATTACK,
	RANGED_ATTACK,
	DEFENSIVE
}

# Match states (from MMatch.h)
enum MatchState {
	IN_PROGRESS,
	COMPLETED
}

# Control states (from MMatch.h)
enum ControlState {
	PLAYER,
	CPU,
	NONE
}

# Sentience types for personas (from MPersona.h)
enum SentienceType {
	ORGANIC,
	MECHANICAL
}
