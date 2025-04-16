class_name Dungeon extends Node3D

@export var noise = FastNoiseLite.new()
var bsp = BSP.new()
var chunk = Chunk.new()
var ruin = Ruin.new()

func generate(s = 0):
	seed(s)
	chunk.fill()
	var bounds = AABB(Vector3(0, 0, 0), Vector3(chunk.w, chunk.w, chunk.w))
	var d = 3
	bsp.build(bounds, d, s)
	var waypoints = []
	for leaf in bsp.leaves():
		var r = room(leaf)
		if r:
			waypoints.append(r.position + (r.size / 2).floor())
	if waypoints.size() > 1:
		for i in range(waypoints.size() - 1):
			tunnel(waypoints[i], waypoints[i+1])
	ruin.dig(chunk, s)
	$Navigation/Skin.mesh = chunk.form()

func room(leaf):
	var m = 1
	var roof = 3
	var gap = Vector3(randi_range(m, 3), randi_range(m, 2), randi_range(m, 3))
	var inset = Vector3(randi() % int(gap.x) + 1, randi() % int(gap.y) + 1,randi() % int(gap.z) + 1)
	var pos = leaf.bounds.position + inset
	var size = leaf.bounds.size - (gap + inset)
	if size.x < m or size.y < m or size.z < m:
		return null
	if size.y > roof:
		size.y = roof
	var aabb = AABB(pos, size)
	chunk.dig(aabb)
	return aabb

func tunnel(a, b):
	var p = a.floor()
	var e = b.floor()
	var s = Vector3(3, 3, 3)
	var o = Vector3(1, 1, 1)
	while p.x != e.x:
		chunk.dig(AABB(p - o, s))
		p.x += 1 if e.x > p.x else -1
	while p.y != e.y:
		chunk.dig(AABB(p - o, s))
		p.y += 1 if e.y > p.y else -1
	while p.z != e.z:
		chunk.dig(AABB(p - o, s))
		p.z += 1 if e.z > p.z else -1
