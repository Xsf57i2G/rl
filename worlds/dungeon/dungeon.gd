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
	bsp.build(bounds, d)
	for leaf in bsp.leaves():
		room(leaf)
	$Navigation/Skin.mesh = chunk.build()

func room(leaf):
	var gap = 2
	var at = leaf.bounds.position + Vector3(1, 1, 1)
	var s = leaf.bounds.size - Vector3(gap, gap, gap)
	if s.x < gap or s.y < gap or s.z < gap:
		return
	var r = AABB(at, s)
	chunk.dig(r)
