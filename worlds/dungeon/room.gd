class_name Room extends Node3D

var size = 4

func dig(c):
	for x in size:
		for y in size:
			for z in size:
				var at = Vector3(x, y, z)
				c.dig(Vector3(position) + at)
