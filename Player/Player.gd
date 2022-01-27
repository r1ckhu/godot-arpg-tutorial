extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 120
var roll_vector = Vector2.UP

onready var animaTree = $AnimationTree
onready var animaState = animaTree.get("parameters/playback")
onready var swordHitbox = $Position2D/SwordHitbox

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE


func _ready():
	animaTree.active = true

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
		ROLL:
			roll_state()
			
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") -Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animaTree.set("parameters/Run/blend_position",input_vector)
		animaTree.set("parameters/Idle/blend_position",input_vector) #保存上次移动时的向量
		animaTree.set("parameters/Attack/blend_position",input_vector)
		animaTree.set("parameters/Roll/blend_position",roll_vector)
		animaState.travel("Run")
		velocity = input_vector * speed
	else:
		animaState.travel("Idle")
		velocity = Vector2.ZERO
		
	#move_and_slide(velocity)
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func roll_state():
	animaState.travel("Roll")
	velocity = speed * roll_vector
	velocity = move_and_slide(velocity)

func roll_finished():
	velocity = 0
	state = MOVE

func attack_state():
	animaState.travel("Attack")

func attack_finished():
	state = MOVE
