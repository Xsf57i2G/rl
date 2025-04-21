var noise = FastNoiseLite.new()

func dig(c):
	for at in c.b.keys():
		if c.b.has(at):
			var n = noise.get_noise_3dv(at)
			if n > 0.5:
				c.b.erase(at)
