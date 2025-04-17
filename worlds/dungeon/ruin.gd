class_name Ruin extends Node3D

var noise = FastNoiseLite.new()

func dig(c, s = 0):
	noise.seed = s
	for x in c.w:
		for y in c.w:
			for z in c.w:
				var spot = Vector3(x, y, z)
				var n = noise.get_noise_3dv(spot)
				if n > .1 and c.world.has(spot):
					var d = 1 + n * 2
					var type = c.world[spot].type
					if type == Chunk.Type.BRICK:
						d = min(d, 1)
					c.hurt(spot, d)
