extends Node2D

var level_data = null

func _draw():
	pass
	#var lookup = {
		#"start": Color.CHARTREUSE,
		#"empty": Color.BLUE,
		#"special": Color.YELLOW,
	#}
	#var data = (level_data as LevelData).data
	#for entry in data.values():
		#var x = entry["x"] * 100
		#var y = entry["y"] * 100
		#draw_rect(Rect2(x, y, 80, 80), lookup[entry["type"]])

func _ready():
	level_data = LevelData.new(20)
	var room_width = 26
	var room_height = 20
	for entry in level_data.data.values():
		var x = entry["x"] * room_width
		var y = entry["y"] * room_height
		for dx in range(room_width):
			for dy in range(room_height):
				$TileMap.set_cell(0, Vector2i(x + dx, y + dy),1,Vector2i.ZERO)
		for dx in range(room_width):
			$TileMap.set_cell(0, Vector2i(x + dx, y),0,Vector2i.ZERO)
			$TileMap.set_cell(0, Vector2i(x + dx, y + room_height - 1),0,Vector2i.ZERO)
		for dy in range(room_height):
			$TileMap.set_cell(0, Vector2i(x, y + dy),0,Vector2i.ZERO)
			$TileMap.set_cell(0, Vector2i(x + room_width - 1, y + dy),0,Vector2i.ZERO)
		var doors: Array[int] = entry["doors"]
		if doors.has(0):
			$TileMap.set_cell(0, Vector2i(x + room_width - 1, y + room_height/2-1),1,Vector2i.ZERO)
			$TileMap.set_cell(0, Vector2i(x + room_width - 1, y + room_height/2),1,Vector2i.ZERO)
		if doors.has(3):
			$TileMap.set_cell(0, Vector2i(x + room_width/2-1, y),1,Vector2i.ZERO)
			$TileMap.set_cell(0, Vector2i(x + room_width/2, y),1,Vector2i.ZERO)
		if doors.has(2):
			$TileMap.set_cell(0, Vector2i(x, y + room_height/2-1),1,Vector2i.ZERO)
			$TileMap.set_cell(0, Vector2i(x, y + room_height/2),1,Vector2i.ZERO)
		if doors.has(1):
			$TileMap.set_cell(0, Vector2i(x + room_width/2-1, y + room_height-1),1,Vector2i.ZERO)
			$TileMap.set_cell(0, Vector2i(x + room_width/2, y + room_height-1),1,Vector2i.ZERO)
