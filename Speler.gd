extends CharacterBody3D
var extra_vel=Vector3.ZERO
@onready var neck = $neck
@onready var cam = $neck/cam
@onready var sprite = $neck/cam/dashSprite
var extraVelMulti =15
var jumped=0
var dashNum := 0
var maxDashAmt := 1
var path=null
func _input(event):
	path=get_parent().get_node("path")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x*0.01)
		cam.rotate_x(-event.relative.y*0.01)
		cam.rotation.x=clamp(cam.rotation.x,deg_to_rad(-90),deg_to_rad(90))
	path.curve.add_point(global_transform.origin)
const SPEED = 5.0
const JUMP_VELOCITY = 6.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func dash():
	dashNum += 1
	if sign(velocity.y) == -1:
		velocity.y=0
	extra_vel+=(sprite.global_transform.origin-cam	.global_transform.origin).normalized()*extraVelMulti
	extra_vel=lerp(extra_vel,Vector3.ZERO,0.1)
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		gravity+=0.1
	else:
		jumped=0
		velocity.y = 0.0
		dashNum = 0
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor_only() and jumped==0:
		velocity.y = JUMP_VELOCITY
		jumped=1
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor() and not is_on_wall() and jumped==1:
		velocity.y = JUMP_VELOCITY
		jumped=2
	if !is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y>(JUMP_VELOCITY/2):
			velocity.y=JUMP_VELOCITY/2
		if Input.is_action_just_released("ui_accept") and velocity.y>(JUMP_VELOCITY+(JUMP_VELOCITY/2)) and jumped==2:
			velocity.y=JUMP_VELOCITY/2
	if Input.is_action_just_pressed("dash") and dashNum<maxDashAmt:
		dash()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	extra_vel=lerp(extra_vel,Vector3.ZERO,0.1)
	velocity+=Vector3(extra_vel.x,0,extra_vel.z)
	move_and_slide()

