extends CharacterBody2D

const WALK_SPEED := 200
const RUN_SPEED := 400
enum State { WALK, RUN }
@onready var state: State

func _physics_process(delta: float) -> void:
	state = State.RUN if Input.is_action_pressed("traverse_run") else State.WALK
	var speed: float = RUN_SPEED if state == State.RUN else WALK_SPEED
	var input_dir := Input.get_vector("traverse_left", "traverse_right", "traverse_up", "traverse_down")
	self.velocity = input_dir * speed
	figure_out_animation(input_dir, state)
	move_and_slide()

func figure_out_animation(vector: Vector2, character_state: State):
	var anim: String
	var dir: String
	if vector == Vector2.ZERO:
		anim = "idle"
		%visuals.play(anim)
		return
	if vector.x != 0: # there is horizontal movement
		anim = "right"
		if vector.x < 0:
			%visuals.flip_h = true
		else:
			%visuals.flip_h = false
	elif vector.y != 0: # there is exclusively vertical movement
		anim = "down" if vector.y > 0 else "up"
	anim += "_run" if character_state == State.RUN else "_walk"
	print("anim: %s" % anim)
	%visuals.play(anim)
	
	
