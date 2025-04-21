@tool

extends EditorScript

func _run():
	var d = "res://models"
	DirAccess.make_dir_absolute(d)
	var fs = DirAccess.get_files_at(d)
	for f in fs:
		if f.ends_with(".glb"):
			proc(d.path_join(f), d)

func proc(p, d):
	var s = load(p)
	if !s:
		return
	var i = s.instantiate()
	var ms = find(i)
	for m in ms:
		var h = m.mesh
		if h:
			var n = m.name if m.name else str(h.get_instance_id())
			var o = d.path_join(n + ".res")
			ResourceSaver.save(h, o)
	i.free()

func find(n):
	var r = []
	if n is MeshInstance3D:
		r.append(n)
	for c in n.get_children():
		r.append_array(find(c))
	return r

