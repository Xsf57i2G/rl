@tool

class_name Chunk extends Resource

var s = SurfaceTool.new()
@export var w = 16
var b = {}

func _init():
	for x in w:
		for y in w:
			for z in w:
				var at = Vector3(x,y,z)
				b[at] = Block.new(Block.STONE)

func hurt(at):
	if not b.has(at):
		return
	var blk = b[at]
	if blk.hurt():
		b.erase(at)

func dig(a):
	var p1 = a.position.floor()
	var p2 = (a.position + a.size).ceil()
	for x in range(int(p1.x), int(p2.x)):
		for y in range(int(p1.y), int(p2.y)):
			for z in range(int(p1.z), int(p2.z)):
				b.erase(Vector3(x,y,z))

func place(at, t = Block.STONE):
	if inside(at):
		b[at] = Block.new(t)

func inside(at):
	return (at.x >= 0 and at.y >= 0 and at.z >= 0 and at.x < w and at.y < w and at.z < w)

func side(at, d):
	s.set_normal(d)
	s.set_color(Color.WHITE)
	var pts = map(d)
	for v in [0, 2, 1, 0, 3, 2]:
		s.add_vertex(at + pts[v])

func map(d):
	match d:
		Vector3.UP:
			return [Vector3(0, 1, 0), Vector3(1, 1, 0), Vector3(1, 1, 1), Vector3(0, 1, 1)]
		Vector3.DOWN:
			return [Vector3(0, 0, 0), Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(1, 0, 0)]
		Vector3.LEFT:
			return [Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(0, 1, 1), Vector3(0, 0, 1)]
		Vector3.RIGHT:
			return [Vector3(1, 0, 0), Vector3(1, 0, 1), Vector3(1, 1, 1), Vector3(1, 1, 0)]
		Vector3.FORWARD:
			return [Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(1, 1, 0), Vector3(0, 1, 0)]
		Vector3.BACK:
			return [Vector3(0, 0, 1), Vector3(0, 1, 1), Vector3(1, 1, 1), Vector3(1, 0, 1)]

func cube(at):
	for d in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
		var n = at + d
		if not b.has(n):
			side(at, d)

func form():
	s.begin(Mesh.PRIMITIVE_TRIANGLES)
	for at in b:
		cube(at)
	s.index()
	return s.commit()

func navmesh():
	var n = NavigationMesh.new()
	var m = s.commit()
	if m == null or m.get_surface_count() == 0:
		return n
	var a = m.surface_get_arrays(0)
	var vtx = a[Mesh.ARRAY_VERTEX]
	var idx = a[Mesh.ARRAY_INDEX]
	if vtx == null or idx == null:
		return n
	s.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in idx.size() / 3:
		var i0 = idx[i * 3]
		var i1 = idx[i * 3 + 1]
		var i2 = idx[i * 3 + 2]
		var v0 = vtx[i0]
		var v1 = vtx[i1]
		var v2 = vtx[i2]
		var norm = (v1 - v0).cross(v2 - v0)
		if norm.dot(Vector3.DOWN) > 0.1:
			s.set_normal(Vector3.UP)
			s.add_vertex(v0)
			s.add_vertex(v2)
			s.add_vertex(v1)
	s.index()
	var nm = s.commit()
	if nm != null and nm.get_surface_count() > 0:
		n.create_from_mesh(s.commit())
	return n

func collider():
	var c = ConcavePolygonShape3D.new()
	var m = s.commit()
	c.set_faces(m.get_faces())
	return c
