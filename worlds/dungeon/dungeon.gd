@tool

class_name Dungeon extends StaticBody3D

class Leaf:
	var b
	var l
	var r
	var p = Vector3.ZERO
	var d
	
	func _init(b, pos = null, d = null):
		self.b = b
		self.d = d
		self.p = pos if pos else b.position
	
	func split():
		var s = b.size
		var i = s.max_axis_index()
		if s[i] < 4: return false
		
		var n = d.n
		var v = n.get_noise_3dv(p)
		var f = abs(v) * 0.8 + 0.1
		if v < 0: f = 1.0 - f
		var c = s[i] * f
		
		var a = AABB(b.position, b.size)
		var t = AABB(b.position, b.size)
		a.size[i] = c
		t.position[i] += c
		t.size[i] -= c
		
		v += 2
		l = Leaf.new(a, p + Vector3(1,2,3) * v, d)
		r = Leaf.new(t, p + Vector3(3,1,2) * v, d)
		return true

@export_tool_button("Generate", "RandomNumberGenerator") var button = generate
@export var pad = 1
@export var height = 5
@export var levels = 3
@export var depth = 4
@export var seed_value = randi()
@export var chunk = Chunk.new()
@export var noise = FastNoiseLite.new()
@export var patterns := [
	Ruin.new(),
]
@export_group("Misc")

var root
var n

func _ready():
	if noise:
		noise.seed = seed_value
	n = noise
	generate()

func build(b, d):
	n = noise
	var r = RandomNumberGenerator.new()
	r.seed = n.seed
	var p = Vector3(r.randf(), r.randf(), r.randf()) * b.size.length()
	root = Leaf.new(b, p, self)
	d = d if d is int and d >= 0 else depth
	split(root, d)

func split(l, d):
	if l == null or d < 0: return
	if d > 0 and l.split():
		split(l.l, d - 1)
		split(l.r, d - 1)

func find():
	var r = []
	var q = [root]
	while q:
		var x = q.pop_front()
		if x.l: 
			q.append(x.l)
			q.append(x.r)
		else: r.append(x)
	return r

func generate():
	seed_value = randi()
	var s = seed_value
	for gen in patterns:
		gen.seed_value = s
		gen.noise.seed = s
	noise.seed = s
	n = noise
	chunk.b.clear()
	var l = max(1, levels)
	var h = max(1, min(height, floor(chunk.w/l)))
	var vs = h + pad
	for i in l:
		var y = i * vs
		if y + h > chunk.w: continue
		root = null
		noise.seed = randi()
		n = noise
		build(AABB(Vector3.ZERO, Vector3(chunk.w, chunk.w, chunk.w)), depth)
		for f in find():
			room(f, y, h)
	$Navigation/Skin.mesh = chunk.form()
	$Collision.shape = chunk.collider()
	$Navigation.navigation_mesh = chunk.navmesh()
	notify_property_list_changed()

func room(f, y, h):
	var b = f.b
	var s = b.position
	var e = b.position + b.size
	s.x = floor(s.x); s.z = floor(s.z); s.y = y
	e.x = ceil(e.x); e.z = ceil(e.z); e.y = min(y + h, chunk.w)
	if s.y >= e.y or not AABB(s, e - s).has_volume(): return
	if e.x - s.x < 5 or e.z - s.z < 5:
		return
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
	var k = chunk.b.keys()
	if k: n.at = k.pick_random()
