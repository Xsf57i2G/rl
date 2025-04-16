class_name Ruin extends Node3D

var noise = FastNoiseLite.new()

func dig(c, s = 0):
	noise.seed = s
	for x in c.w:
		for y in c.w:
			for z in c.w:
				var at = Vector3(x, y, z)
				var n = noise.get_noise_3dv(at)
				if n > .1:
					var damage = 1 + int(n * 2)
					c.hurt(at, damage)
