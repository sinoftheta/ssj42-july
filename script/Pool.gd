extends Node
class_name Pool

var active: Dictionary = {}
var inactive: Array = []
var scene: PackedScene

func get_new() -> Node:
	var node: Node
	if len(inactive) > 0:
		node = inactive.pop_back()
	else:
		node = scene.instantiate()
		if node.has_method("set_pool"):
			node.set_pool(self)
	if node.has_method("init"):
		node.init()
	active[node.get_instance_id()] = node
	print(active.size())
	return node

func del(node: Node):
	active.erase(node.get_instance_id())
	if node.get_parent() != null:
		node.get_parent().remove_child(node)
	inactive.push_back(node)
