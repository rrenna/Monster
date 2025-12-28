## Entity - Base class for all game entities (units, structures, projectiles)
## Ported from MEntity.h/mm and MObject.h/m
class_name Entity
extends CharacterBody2D

signal health_changed(new_health: float, old_health: float)
signal entity_died()
signal activity_state_changed(new_state: int)

@export var entity_name: String = ""
@export var max_health: float = 100.0

var team: Team
var health: float = 100.0
var activity_state: int = Enums.ActivityState.IDLE  # Enums.ActivityState
var grid_position: Vector2i = Vector2i.ZERO

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var collision_shape: CollisionShape2D = $CollisionShape2D if has_node("CollisionShape2D") else null


func _ready() -> void:
	health = max_health
	_update_grid_position()


func _physics_process(_delta: float) -> void:
	update()


## Initialize the entity with name, position, and team
func initialize(p_name: String, p_position: Vector2i, p_team: Team) -> void:
	entity_name = p_name
	grid_position = p_position
	team = p_team
	position = GameSettings.grid_to_world(p_position)
	EntityManager.add_entity(self, Enums.EntityType.UNIT)


## Update method called every physics frame
func update() -> void:
	pass  # Override in subclasses


## Get the bounding rectangle of this entity
func get_rect() -> Rect2:
	if sprite:
		return Rect2(
			position - sprite.texture.get_size() / 2,
			sprite.texture.get_size()
		)
	return Rect2(position - Vector2(16, 16), Vector2(32, 32))


## Receive a message from the message bus
func receive_message(message: MessageBus.Message) -> void:
	match message.message_type:
		Enums.MessageType.UPDATE:
			update()
		Enums.MessageType.TRANSFORMATION:
			perform_transformation(message.value)
		Enums.MessageType.DAMAGE:
			if message.value is Dictionary:
				perform_damage(message.value.damage, message.value.force)
			else:
				perform_damage(message.value, Vector2.ZERO)
		Enums.MessageType.SPRITE_CHANGE:
			perform_sprite_change(message.value)
		Enums.MessageType.ACTIVITY_STATE_CHANGE:
			set_activity_state(message.value)


## Send a message through the message bus
func send_message(message: MessageBus.Message) -> void:
	MessageBus.queue_message(message)


## Apply a transformation/animation to this entity
func perform_transformation(action: Variant) -> void:
	if action is Tween:
		# Tween is already set up externally
		pass
	elif action is Dictionary:
		# Dictionary with transformation properties
		var tween = create_tween()
		if action.has("position"):
			tween.tween_property(self, "position", action.position, action.get("duration", 0.3))
		if action.has("rotation"):
			tween.tween_property(self, "rotation", action.rotation, action.get("duration", 0.3))


## Apply damage to this entity
func perform_damage(damage: float, force: Vector2 = Vector2.ZERO) -> void:
	var old_health = health
	health = max(0, health - damage)
	health_changed.emit(health, old_health)

	# Apply knockback force
	if force != Vector2.ZERO:
		perform_shake_with_force(force)

	# Check for death
	if health <= 0:
		_on_death()


## Change the sprite for this entity
func perform_sprite_change(sprite_name: String) -> void:
	if sprite:
		var texture = load("res://resources/sprites/" + sprite_name + ".png")
		if texture:
			sprite.texture = texture


## Perform a shake effect
func perform_shake() -> void:
	perform_shake_with_force(Vector2(5, 0))


## Perform a shake effect with a specific force
func perform_shake_with_force(force: Vector2) -> void:
	var original_pos = position
	var tween = create_tween()
	tween.tween_property(self, "position", position + force, 0.05)
	tween.tween_property(self, "position", position - force * 0.5, 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)


## Set the activity state
func set_activity_state(state: int) -> void:
	if activity_state != state:
		activity_state = state
		activity_state_changed.emit(state)
		_update_animation()


## Update animation based on activity state
func _update_animation() -> void:
	# Override in subclasses to handle animation changes
	pass


## Update grid position from world position
func _update_grid_position() -> void:
	grid_position = GameSettings.world_to_grid(position)


## Handle entity death
func _on_death() -> void:
	entity_died.emit()
	EntityManager.remove_entity(self, Enums.EntityType.UNIT)
	queue_free()
