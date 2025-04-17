class_name Chunk

var st = SurfaceTool.new()
var w = 16
var world = []

func _init():
	for x in w:
		for y in w:
			for z in w:
				world.append(Vector3(x,y,z))

func hurt(spot, n = 1):
	if spot.x == 0 or spot.x == w-1 or spot.y == 0 or spot.y == w-1 or spot.z == 0 or spot.z == w-1:
		return
	var i = world.find(spot)
	if i >= 0:
		world.remove_at(i)

func dig(area, t = null):
	var a = area.position.floor()
	var b = (area.position + area.size).ceil()
	var area_int = AABB(a, b - a)
	var walls = []
	var erases = []
	for x in range(int(a.x), int(b.x)):
		for y in range(int(a.y), int(b.y)):
			for z in range(int(a.z), int(b.z)):
				var spot = Vector3(x, y, z)
				if world.has(spot):
					erases.append(spot)
					if t != null:
						for way in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
							var next = spot + way
							if inside(next) and world.has(next) and not area_int.has_point(next):
								walls.append(next)
	for spot in erases:
		var i = world.find(spot)
		if i >= 0:
			world.remove_at(i)
	for spot in walls:
		if not spot in erases and not world.has(spot):
			world.append(spot)

func place(spot, block_type = "STONE"):
	if inside(spot) and not world.has(spot):
		world.append(spot)

func inside(spot):
	return (spot.x >= 0 and spot.y >= 0 and spot.z >= 0 and spot.x < w and spot.y < w and spot.z < w)

func side(spot, way):
	st.set_normal(way)
	st.set_color(Color.WHITE)
	var points = map(way)
	for v in [0, 1, 2, 0, 2, 3]:
		st.add_vertex(spot + points[v])

func map(way):
	match way:
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

func cube(s):
	for d in [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]:
		var n = s + d
		if not world.has(n):
			side(s, d)

func form():
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for spot in world:
		cube(spot)
	st.index()
	return st.commit()

func navmesh():
	var n = NavigationMesh.new()
	var m = st.commit()
	if m == null or m.get_surface_count() == 0:
		return n
	var a = m.surface_get_arrays(0)
	var vtx = a[Mesh.ARRAY_VERTEX]
	var idx = a[Mesh.ARRAY_INDEX]
	if vtx == null or idx == null:
		return n
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in idx.size() / 3:
		var i0 = idx[i * 3]
		var i1 = idx[i * 3 + 1]
		var i2 = idx[i * 3 + 2]
		var v0 = vtx[i0]
		var v1 = vtx[i1]
		var v2 = vtx[i2]
		var norm = (v1 - v0).cross(v2 - v0)
		if norm.dot(Vector3.DOWN) > 0.1:
			st.set_normal(Vector3.UP)
			st.add_vertex(v0)
			st.add_vertex(v2)
			st.add_vertex(v1)
	st.index()
	var nm = st.commit()
	if nm != null and nm.get_surface_count() > 0:
		n.create_from_mesh(nm)
	return n

func collider():
	var c = ConcavePolygonShape3D.new()
	var m = st.commit()
	c.set_faces(m.get_faces())
	return c
