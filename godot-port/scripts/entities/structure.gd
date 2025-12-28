## Structure - Static map objects (obstacles, buildings)
## Ported from MStructure.h/mm
class_name Structure
extends Entity

@export var crushable: bool = false


func _ready() -> void:
	super._ready()


## Initialize structure
func initialize(p_name: String, p_position: Vector2i, p_team: Team) -> void:
	super.initialize(p_name, p_position, p_team)
	EntityManager.add_entity(self, Enums.EntityType.STRUCTURE)


## Override damage to check crushable
func perform_damage(damage: float, force: Vector2 = Vector2.ZERO) -> void:
	if crushable:
		super.perform_damage(damage, force)
	# Non-crushable structures ignore damage


## Handle destruction
func _on_death() -> void:
	EntityManager.remove_entity(self, Enums.EntityType.STRUCTURE)
	queue_free()
