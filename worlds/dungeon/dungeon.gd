class_name Dungeon extends Node3D

var bsp = BSP.new()
var chunk = Chunk.new()
var ruin = Ruin.new()

func generate(s = 0):
	var bounds = AABB(Vector3.ZERO, Vector3(chunk.w, chunk.w, chunk.w))
	bsp.build(bounds, 3)
	var p = null
	for leaf in bsp.leaves():
		var root = room(leaf)
		if root:
			if p != null:
				join(p, root)
			p = root
	ruin.dig(chunk, s)
	$Navigation/Skin.mesh = chunk.form()
	$Navigation.navigation_mesh = chunk.navmesh()
	$Collision.shape = chunk.collider()

func room(leaf):
	var gap = Vector3(1, 1, 1)
	var inset = Vector3(1, 1, 1)
	var spot = leaf.bounds.position + inset
	var s = leaf.bounds.size - (gap + inset)
	if s.x < 2 or s.y < 2 or s.z < 2:
		return null
	if s.y > 3:
		s.y = 3
	var box = AABB(spot, s)
	chunk.dig(box, "BRICK")
	return box

func join(a, b):
	var tunnel_size = Vector3(3, 3, 3)
	var from = Vector3(a.position.x + a.size.x, a.position.y + a.size.y, a.position.z + a.size.z).floor()
	var end_pos = Vector3(b.position.x + b.size.x, b.position.y + b.size.y, b.position.z + b.size.z).floor()
	var current = from
	while current.x != end_pos.x:
		chunk.dig(AABB(current, tunnel_size), "BRICK")
		current.x += 1 if end_pos.x > current.x else -1
	while current.z != end_pos.z:
		chunk.dig(AABB(current, tunnel_size), "BRICK")
		current.z += 1 if end_pos.z > current.z else -1
	while current.y != end_pos.y:
		chunk.dig(AABB(current, tunnel_size), "BRICK")
		current.y += 1 if end_pos.y > current.y else -1
	chunk.dig(AABB(current, tunnel_size), "BRICK")

func spawn(what):
	var at = chunk.world.pick_random()
	what.position = Vector3(at.x, at.y + 1.5, at.z)
