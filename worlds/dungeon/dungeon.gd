@tool
class_name Dungeon extends Node3D

@export_tool_button("Generate") var button = generate
@export var pad = 1
@export var height = 5
@export var levels = 3
@export var chunk = Chunk.new()
@export var bsp = BSP.new()
@export var ruin = Ruin.new()

func _ready():
	generate()

func generate():
	chunk.b.clear()
	var l = max(1, levels)
	var h = max(1, min(height, floor(chunk.w/l)))
	var vs = h + pad
	for i in l:
		var y = i * vs
		if y + h > chunk.w:
			continue
		bsp.build(AABB(Vector3.ZERO, Vector3(chunk.w, chunk.w, chunk.w)), bsp.depth)
		var ls = bsp.find()
		for f in ls:
			room(f, y, h)
	ruin.dig(chunk)
	$Navigation/Skin.mesh = chunk.form()
	$Collision.shape = chunk.collider()
	$Navigation.navigation_mesh = chunk.navmesh()

func room(f, y, h):
	var b = f.b
	var s = b.position
	var e = b.position + b.size
	s.x = floor(s.x)
	s.z = floor(s.z)
	e.x = ceil(e.x)
	e.z = ceil(e.z)
	s.y = y
	e.y = min(y + h, chunk.w)
	if s.y >= e.y or not AABB(s, e - s).has_volume():
		return
	chunk.dig(AABB(s, e - s))
	var os = s + Vector3(pad, 0, pad)
	var oe = e - Vector3(pad, 0, pad)
	if os.x < oe.x and os.z < oe.z:
		for x in range(int(os.x), int(oe.x)):
			for j in range(int(s.y), int(e.y)):
				for z in range(int(os.z), int(oe.z)):
					chunk.place(Vector3(x, j, z), Block.BRICK)

func spawn(n):
	var k = chunk.b.keys()
	if k: n.at = k.pick_random()
