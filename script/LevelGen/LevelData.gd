extends Node

class_name LevelData

var data: Dictionary = {}

func to_key(x: int, y: int) -> String:
	return str(x) + ":" + str(y)

func to_coords(key: String) -> Array[int]:
	var arr := key.split(":")
	return [int(arr[0]), int(arr[1])]

func add_entry(dict: Dictionary, x: int, y: int, type: String):
	var obj = {"x":x, "y":y, "type": type}
	var key = to_key(x, y)
	if dict.has(key):
		printerr("duplicate entry: " + key)
		return
	dict[key] = obj

func get_adj(x: int, y: int) -> Array[String]:
	var res: Array[String]= []
	var key := ""
	key = to_key(x+1,y)
	res.push_back(key)
	key = to_key(x,y+1)
	res.push_back(key)
	key = to_key(x-1,y)
	res.push_back(key)
	key = to_key(x,y-1)
	res.push_back(key)
	return res

func get_neighbors(dict: Dictionary, x: int, y: int) -> Array[String]:
	var res := []
	var key := ""
	key = to_key(x+1,y)
	if dict.has(key):
		res.push_back(key)
	key = to_key(x,y+1)
	if dict.has(key):
		res.push_back(key)
	key = to_key(x-1,y)
	if dict.has(key):
		res.push_back(key)
	key = to_key(x,y-1)
	if dict.has(key):
		res.push_back(key)
	return res

func get_random(dict: Dictionary) -> Dictionary:
	if dict.size() == 0:
		return {}
	var keys := dict.keys()
	var idx: int = floor(randf()*len(keys))
	var key: String = keys[idx]
	var res = dict[key]
	dict.erase(key)
	return res 

func _init(size: int):
	var open := {}
	var closed := {}
	add_entry(open, 0, 0, "start")
	while closed.size() < size:
		var node = get_random(open)
		add_entry(closed, node["x"], node["y"], node["type"])
		var neig := get_adj(node["x"], node["y"])
		for n in neig:
			if open.has(n):
				pass
			elif closed.has(n):
				pass
			else:
				var coord = to_coords(n)
				add_entry(open, coord[0], coord[1], "empty")
	
	# while map is under a given size
	# get a random room from open
	# add it to closed
	# add its neigbors to open if they are not already in open or closed
	
	# once the dungeon shape is settled, identify rooms with only one neighbor
	#print(JSON.stringify(open))
	#print(JSON.stringify(closed))
	data = closed
