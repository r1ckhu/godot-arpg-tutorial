extends Node2D


func create_GrassEffect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	var ysort = get_node("/root/World/YSort")
	ysort.add_child(grassEffect)
	grassEffect.global_position = global_position
		
func _on_Area2D_area_entered(_area):
	create_GrassEffect()
	queue_free()
	
