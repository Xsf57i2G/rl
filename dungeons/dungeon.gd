extends StaticBody3D

var noise = FastNoiseLite.new()
var chunk = load("res://dungeons/chunk.gd").new()
var pad = 1
var height = 5
var levels = 3
var depth = 4
var root

func _ready():
	chunk.b.clear()
	var v = max(1, levels)
	var h = max(1, min(height, floor(chunk.w / v)))
	var z = h + pad
	for i in v:
		var y = i * z
		if y + h > chunk.w:
			continue
		root = null
		noise.seed = randi()
		build(AABB(Vector3.ZERO, Vector3(chunk.w, chunk.w, chunk.w)))
		for f in find():
			room(f, y, h)
	$Navigation/Mesh.mesh = chunk.form()
	$Collision.shape = chunk.collider()
	$Navigation.navigation_mesh = chunk.nav()

func build(b):
	var g = RandomNumberGenerator.new()
	g.seed = noise.seed
	var p = Vector3(g.randf(), g.randf(), g.randf()) * b.size.length()
	root = [b, null, null, p]
	split(root, depth)

func div(l):
	var b = l[0]
	var p = l[3]
	var s = b.size
	var i = s.max_axis_index()
	if s[i] < 4: return false
	var v = noise.get_noise_3dv(p)
	var f = abs(v) * 0.8 + 0.1
	if v < 0: f = 1.0 - f
	var c = s[i] * f
	var a = AABB(b.position, b.size)
	var t = AABB(b.position, b.size)
	a.size[i] = c
	t.position[i] += c
	t.size[i] -= c
	v += 2
	l[1] = [a, null, null, p + Vector3(1, 2, 3) * v]
	l[2] = [t, null, null, p + Vector3(3, 1, 2) * v]
	return true

func split(l, d):
	if l == null or d < 0: return
	if d > 0 and div(l):
		split(l[1], d - 1)
		split(l[2], d - 1)

func find():
	var a = []
	var q = [root]
	while q:
		var x = q.pop_front()
		if x[1]:
			q.append(x[1])
			q.append(x[2])
		else:
			a.append(x)
	return a

func room(f, y, h):
	var b = f[0]
	var s = b.position
	var e = b.position + b.size
	s.x = floor(s.x)
	s.z = floor(s.z)
	s.y = y
	e.x = ceil(e.x)
	e.z = ceil(e.z)
	e.y = min(y + h, chunk.w)
	if s.y >= e.y or not AABB(s, e - s).has_volume(): return
	if e.x - s.x < 5 or e.z - s.z < 5: return
	chunk.dig(AABB(s, e - s))
	var o = Vector3(pad, 0, pad)
	var a = s + o
	var z = e - o
	if a.x < z.x and a.z < z.z:
		for x in range(int(a.x), int(z.x)):
			for j in range(int(s.y), int(e.y)):
				for k in range(int(a.z), int(z.z)):
					chunk.place(Vector3(x, j, k), Block.BRICK)

func spawn(n):
	if chunk:
		var k = chunk.b.keys()
		if k: n.at = k.pick_random()
