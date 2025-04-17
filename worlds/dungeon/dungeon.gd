class_name Dungeon extends Node3D

var bsp = BSP.new()
var chunk = Chunk.new()
var ruin = Ruin.new()
var rooms = []

func generate(s = 0):
	randomize()
	chunk.fill()
	var bounds = AABB(Vector3.ZERO, Vector3(chunk.w, chunk.w, chunk.w))
	bsp.build(bounds, 5)
	var room_centers = []
	rooms.clear()
	for leaf in bsp.leaves():
		var r = room(leaf)
		if r:
			room_centers.append(r.position + (r.size / 2).floor())
			rooms.append(r)
	if room_centers.size() > 1:
		for i in range(room_centers.size() - 1):
			tunnel(room_centers[i], room_centers[i+1])
	ruin.dig(chunk, s)
	var navigation = $Navigation
	var skin = $Navigation/Skin
	var collision = $Collision
	skin.mesh = chunk.form()
	navigation.navigation_mesh = chunk.navmesh()
	collision.shape = chunk.collider(skin.mesh)

func room(leaf):
	var gap = Vector3(1, 1, 1)
	var inset = Vector3(1, 1, 1)
	var pos = leaf.bounds.position + inset
	var size = leaf.bounds.size - (gap + inset)
	if size.x < 2 or size.y < 2 or size.z < 2:
		return null
	if size.y > 3:
		size.y = 3
	var box = AABB(pos, size)
	chunk.dig(box, Chunk.Type.BRICK)
	return box

func tunnel(a, b):
	var p = a.floor()
	var e = b.floor()
	var s = Vector3(3, 3, 3)
	var o_horizontal = Vector3(1, 1, 1)
	var o_vertical = Vector3(1, 0, 1)
	var current_offset = o_horizontal
	while p.x != e.x:
		current_offset = o_horizontal
		chunk.dig(AABB(p - current_offset, s), Chunk.Type.BRICK)
		p.x += 1 if e.x > p.x else -1
	while p.z != e.z:
		current_offset = o_horizontal
		chunk.dig(AABB(p - current_offset, s), Chunk.Type.BRICK)
		p.z += 1 if e.z > p.z else -1
	while p.y != e.y:
		current_offset = o_vertical
		chunk.dig(AABB(p - current_offset, s), Chunk.Type.BRICK)
		p.y += 1 if e.y > p.y else -1
	chunk.dig(AABB(p - current_offset, s), Chunk.Type.BRICK)

func spawn(what):
	var r = rooms[0]
	var i = what.instantiate()
	add_child(i)
	i.position = Vector3(floor(randf_range(r.position.x, r.position.x + r.size.x)) + 0.5, r.position.y, floor(randf_range(r.position.z, r.position.z + r.size.z)) + 0.5)
	return i
