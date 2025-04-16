class_name Ruin extends Node3D

var noise = FastNoiseLite.new()

func dig(c):
	noise.frequency = 0.1
	noise.noise_type = noise.TYPE_VALUE_CUBIC
	noise.fractal_type = noise.FRACTAL_NONE
	for x in c.size:
		for y in c.size:
			for z in c.size:
				var at = Vector3(x, y, z)
				if noise.get_noise_3dv(at) > 0.1:
					c.dig(Vector3(position) + at)
