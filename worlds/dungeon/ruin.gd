@tool
class_name Ruin extends Resource

@export var seed = 0
@export var noise = FastNoiseLite.new()

func dig(c):
	noise.seed = seed
	var k = c.b.keys()
	for at in k:
		if not c.b.has(at) or c.b[at].hp == INF:
			continue
		var e = 0
		for d in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
			var n = at + d
			if not c.inside(n) or not c.b.has(n): e += 1
		var v = (noise.get_noise_3dv(at) + 1) / 2
		if v > 0.3 or e > 3:
			c.b.erase(at)
