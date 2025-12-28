## Projectile - Flying attack objects
## Ported from MProjectile.h/m
class_name Projectile
extends RigidBody2D

signal hit_target(target: Node2D)

@export var damage: float = 10.0

var team: Team
var force: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null


func _ready() -> void:
	# Set initial velocity
	linear_velocity = force * GameSettings.PIXELS_TO_METERS

	# Connect to body entered signal for collision detection
	body_entered.connect(_on_body_entered)


## Initialize projectile
func initialize(p_position: Vector2, p_force: Vector2, p_damage: float, p_team: Team) -> void:
	position = p_position
	force = p_force
	damage = p_damage
	team = p_team


## Handle collision with other bodies
func _on_body_entered(body: Node) -> void:
	if body is Entity:
		var entity = body as Entity
		# Don't hit friendly units
		if entity.team == team:
			return

		# Apply damage
		entity.perform_damage(damage, force.normalized() * 5)
		hit_target.emit(entity)

		# Destroy projectile
		queue_free()
	elif body is TileMapLayer:
		# Hit terrain
		queue_free()


## Called when projectile goes off screen or times out
func _on_lifetime_expired() -> void:
	queue_free()
