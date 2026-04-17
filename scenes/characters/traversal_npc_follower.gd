extends CharacterBody2D

const SPEED = 200

@export var following_node: Node
@onready var navagent: NavigationAgent2D = %NavigationAgent2D
@onready var target: Vector2

# some parts copied and adapted from:
# "https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html"
func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navagent.path_desired_distance = 4.0
	navagent.target_desired_distance = 10.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target)

func set_movement_target(movement_target: Vector2):
	navagent.target_position = movement_target

func _physics_process(delta):
	target = following_node.global_position
	if navagent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navagent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * SPEED
	move_and_slide()
