extends KinematicBody2D

var velocity = Vector2.ZERO
var friction = 200
var knockback_distance = 140
onready var stats = $MobStats
onready var sprite = $BatSprite

func _ready():
	stats.max_health = 2
	stats.health = stats.max_health
	sprite.playing = true

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide(velocity)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	print(stats.health)
	velocity = (global_position - area.get_parent().global_position).normalized() \
				*knockback_distance 
	
#	if !("knockback_vector" in area):    #"if object is Object and "property" in object"
#		print("NULL")
#	else:
#		print("Sword")
#		velocity =  area.knockback_vector * 140
	
func _on_MobStats_no_health():
	var EnemyDeathEffect = load("res://Effects/EnemyDeathEffect.tscn")
	var enemyDeathEffect = EnemyDeathEffect.instance()
	var ysort = get_node("/root/World/YSort")
	ysort.add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	queue_free()
	
