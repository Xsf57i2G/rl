class_name Dungeon extends Node3D

var bsp = BSP.new()
var chunk = Chunk.new()
var ruin = Ruin.new()

func generate(s = 0):
	seed(s)
	chunk.size = 16
	chunk.fill()
	var bounds = AABB(Vector3(0, 0, 0), Vector3(chunk.size, chunk.size, chunk.size))
	var d = 3
	bsp.build(bounds, d, s)
	var centers = []
	for leaf in bsp.leaves():
		var r = room(leaf)
		if r:
			centers.append(r.position + (r.size / 2).floor())
	if centers.size() > 1:
		for i in range(centers.size() - 1):
			tunnel(centers[i], centers[i+1])
	$Navigation/Skin.mesh = chunk.build()

func room(leaf):
	var min_gap = 1
	var max_gap = 3
	var gap_x = min_gap + randi() % (max_gap - min_gap + 1)
	var gap_y = min_gap + randi() % (max_gap - min_gap + 1)
	var gap_z = min_gap + randi() % (max_gap - min_gap + 1)
	var offset_x = randi() % gap_x + 1
	var offset_y = randi() % gap_y + 1
	var offset_z = randi() % gap_z + 1
	var at = leaf.bounds.position + Vector3(offset_x, offset_y, offset_z)
	var s = leaf.bounds.size - Vector3(gap_x + offset_x, gap_y + offset_y, gap_z + offset_z)
	if s.x < min_gap or s.y < min_gap or s.z < min_gap:
		return
	var r = AABB(at, s)
	chunk.dig(r, chunk.BRICK)
	return r

func tunnel(a, b):
	var p = a.floor()
	var e = b.floor()
	for axis in ["x", "y", "z"]:
		while p[axis] != e[axis]:
			chunk.dig(AABB(p, Vector3.ONE), chunk.BRICK)
			p[axis] += 1 if e[axis] > p[axis] else -1
