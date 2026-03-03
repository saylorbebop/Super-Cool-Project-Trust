## Main freeroam player character scene. Is on collision mask 2, for detection by camera movers.
extends CharacterBody3D

const MOVEMENT_SPEED = 2.0
const SLOWDOWN_COEFFICIENT = 3 # the higher, the faster. 1 = 1 second to stop after release of mvmnt key.

func _ready() -> void:
	# for the time being, we only have the default model to deal with
	%CharacterModelManager.switch_to(%CharacterModelManager.CharacterModel.DEFAULT)

## most of the weird code in this file relating to axes and direction are all to accomodate
## the static but switching camera in this game's areas; once the camera rotates, pressing W should
## not keep the same meaning!
func get_axes(camera_transform: Transform3D) -> Dictionary:
	var cam_fwd: Vector3 = -camera_transform.basis.z; cam_fwd.y = 0
	var angles: Array = [
		cam_fwd.angle_to(Vector3(0, 0, -1)), cam_fwd.angle_to(Vector3(0, 0, 1)),
		cam_fwd.angle_to(Vector3(-1, 0, 0)), cam_fwd.angle_to(Vector3(1, 0, 0))
	]
	
	var forward: Vector3; var back: Vector3; var left: Vector3; var right: Vector3
	
	match angles.find(angles.min()): # im sorry its ugly but shaddup it works
		0: # cam is facing -z
			forward = Vector3(0, 0, -1); back = Vector3(0, 0, 1)
			left = Vector3(-1, 0, 0);    right = Vector3(1, 0, 0)
		1: # cam is facing +z
			forward = Vector3(0, 0, 1);  back = Vector3(0, 0, -1)
			left = Vector3(1, 0, 0);     right = Vector3(-1, 0, 0)
		2: # cam is facing -x
			forward = Vector3(-1, 0, 0); back = Vector3(1, 0, 0)
			left = Vector3(0, 0, 1);     right = Vector3(0, 0, -1)
		3: # cam is facing +x
			forward = Vector3(1, 0, 0);  back = Vector3(-1, 0, 0)
			left = Vector3(0, 0, -1);    right = Vector3(0, 0, 1)
	
	var result: Dictionary = {"forward": forward, "back": back, "left": left, "right": right}
	return result

var axes := {} # persistent between loops of _physics_process
func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var update_rot: bool = true
	if input_dir == Vector2(0, 0): # only update when you stop moving, so that the change isnt abrupt
		axes = get_axes(Global.camera.global_transform)
		update_rot = false # on the contrary, DON'T update rotation on stop. rotate it on move!
	var direction: Vector3 = (axes["right"] * input_dir.x + axes["back"] * input_dir.y).normalized()
	
	if update_rot: look_at(global_position + direction, Vector3.UP)
	
	if direction:
		velocity.x = direction.x * MOVEMENT_SPEED
		velocity.z = direction.z * MOVEMENT_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SLOWDOWN_COEFFICIENT*MOVEMENT_SPEED*delta)
		velocity.z = move_toward(velocity.z, 0, SLOWDOWN_COEFFICIENT*MOVEMENT_SPEED*delta)
	
	move_and_slide()
