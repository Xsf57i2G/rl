class_name Ruin extends Node3D

var noise = FastNoiseLite.new()

func dig(c, s = 0):
	noise.seed = s
	for x in c.w:
		for y in c.w:
			for z in c.w:
				var p = Vector3(x, y, z)
				var n = noise.get_noise_3dv(p)
				if n > .1 and c.blocks.has(p):
					var d = 1 + n * 2
					c.hurt(p, d)
