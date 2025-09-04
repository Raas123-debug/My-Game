extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var origin = Vector2.ZERO
@onready var end: Area2D = $"../End"

func _ready() -> void:
	origin = global_position

func _physics_process(delta):
	# Animations 
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "run"
	else:
		sprite_2d.animation = "idle"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "run"

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay action
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		# Decelerate when no input is given
		velocity.x = move_toward(velocity.x, 0, 50)

	# Move the character
	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft


func _on_area_2d_body_entered(body: Node2D) -> void:
	global_position = origin


	
