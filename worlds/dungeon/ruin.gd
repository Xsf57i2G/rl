class_name Ruin extends Resource

@export var seed = 0
@export var n = FastNoiseLite.new()

func dig(c):
	var k = c.b.keys()
	for at in k:
		if not c.b.has(at):
			continue
		var b = c.b[at]
		var e = 0
		for d in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
			var n = at + d
			if not c.inside(n) or not c.b.has(n): e += 1
		if b.hp != INF and (n.get_noise_3dv(at) + 1.0) / 2.0 > max(0.0, 0.6 + 0.1 * (b.hp - 1) - e * 0.05):
			c.hurt(at)
