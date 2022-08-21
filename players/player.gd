extends KinematicBody2D

const MAX_SPEED: float = 45.0
const GRAVITY: float = 9.8
const ACCELERATION: float = 400.0
const FRICTION: float = 500.0
const MASS: float = 45.0

var velocity: Vector2 = Vector2.ZERO
var _input_dir: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


func _physics_process(delta) -> void:
    _input_dir.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
    
    if _input_dir.length() != 0:
        # Normalize the magnitude of the vector
        _input_dir = _input_dir.normalized()
        # Applies more velocity to the current velocity
        velocity += _input_dir * ACCELERATION
        # Don't allow higher velocity then MAX_SPEED
        velocity = velocity.clamped(MAX_SPEED)
    else:
        velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
        
    velocity.y += MASS * GRAVITY
        
    move_and_slide(velocity, Vector2.UP)
