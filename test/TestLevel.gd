extends Node2D

var level_data = null

func _draw():
	var data = (level_data as LevelData).data
	for entry in data.values():
		var x = entry["x"] * 100
		var y = entry["y"] * 100
		draw_rect(Rect2(x, y, 80, 80), Color.BLUE)

func _ready():
	level_data = LevelData.new(20)
