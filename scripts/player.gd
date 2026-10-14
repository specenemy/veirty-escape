extends CharacterBody3D

@export var speed: float = 9.0
@export var sens: float = 1.0
@export var jump_force: float = 20.0
@export var gravity_multiplier = 10
@export var camera_pivot: Node3D

var gravity = 9.8

func _ready() -> void:
	print(gravity)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var input_vec = Input.get_vector("left", "right", "backward", "forward")
	var dir = (transform.basis * Vector3(input_vec.x, 0, -input_vec.y)).normalized()
	
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	
	if Input.is_action_pressed("Jump") and is_on_floor():
		velocity.y = jump_force
		
	if not is_on_floor():
		velocity.y -= gravity * gravity_multiplier * delta
		
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sens / 1000)
		
		camera_pivot.rotate_x(-event.relative.y * sens / 1000)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-89.0), deg_to_rad(89.0))
		
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed == true:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
