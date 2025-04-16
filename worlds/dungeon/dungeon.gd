@tool
class_name Dungeon extends Node3D

var noise = FastNoiseLite.new()
var chunk = Chunk.new()

func generate(s = 0):
	chunk.fill()
	var step = 3
	var gap = chunk.size / step
	for x in step:
		for y in step:
			for z in step:
				pass
	$Skin.mesh = chunk.build()
