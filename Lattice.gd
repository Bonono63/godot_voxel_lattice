extends Node3D

var data : ChunkData = ChunkData.new()
var size : Vector3i
var voxel_scale : float
var textures : Texture2DArray = Texture2DArray.new()
var material : ShaderMaterial = ShaderMaterial.new()
var face_count : int = 0

func _init(_size : Vector3i = Vector3i(256,256,256), _voxel_scale : float = 1.0):
	size = _size
	voxel_scale = _voxel_scale
	
	var pathes : Array[String] = ["resources/assets/minecraft/textures/block/dirt.png","resources/assets/minecraft/textures/block/ancient_debris_side.png"]
	var temp : Array[Image] = [Image.create(32,32,false,Image.FORMAT_RGBA8)]
	
	for texture in pathes:
		var image : Image = Image.load_from_file("res://"+texture)
		image.convert(Image.FORMAT_RGBA8)
		print(image.get_format())
		temp.append(image)
	
	textures.create_from_images(temp)
	
	for x in ChunkData.chunk_length:
		for z in ChunkData.chunk_length:
			data.set_index_v(Vector3i(x,2,z), 1)
	
	face_count = (size.x*2)+(size.y*2)+(size.z*2)
	print("face_count: ",face_count)
	print("minecraft render distance equivalent: ",size/16)

func _ready():
	material.shader = load("res://lattice.gdshader")
	material.set_shader_parameter("textures",textures)
	material.set_shader_parameter("data",data.data)
	create_lattice_mesh(size, voxel_scale)

func create_lattice_mesh(_size : Vector3i, _voxel_scale : int) -> void:
	var mesh : Array = []
	mesh.resize(ArrayMesh.ARRAY_MAX)
	mesh[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
	mesh[ArrayMesh.ARRAY_TEX_UV] = PackedVector2Array()
	
	# Positive X
	for x in _size.z:
		#vertices
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0, 1.0, 1.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0, 0.0, 1.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 1.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 1.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 1.0, 1.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0, 1.0, 1.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		
		#uv
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
	
	# Negative X
	for x in _size.z:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3( 0.0, 0.0, 0.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0, 0.0, 0.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0, 1.0, 0.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0, 1.0, 0.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3( 0.0, 1.0, 0.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3( 0.0, 0.0, 0.0)*Vector3(_size.x, _size.y, 1.0))+Vector3(0.0,0.0,x))*_voxel_scale)
		
		#uv
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
		
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
	
	# Positive Z
	for z in _size.x:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 0.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 1.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 1.0, 1.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z+1,0.0,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 1.0, 1.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 1.0, 0.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 0.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z+1,0.0,0.0))*_voxel_scale)
		
		#uv
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
	
	# Negative Z
	for z in _size.x:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 1.0, 1.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 1.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 0.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z,0.0,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 0.0, 0.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 1.0, 0.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0, 1.0, 1.0)*Vector3(1.0, _size.y, _size.z))+Vector3(z,0.0,0.0))*_voxel_scale)
		
		#uv
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
	
	# Positive Y
	for y in _size.y:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0,1.0,1.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0,1.0,1.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0,1.0,0.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0,1.0,0.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0,1.0,0.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0,1.0,1.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		
		#uv
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
		
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
	
	for y in _size.y:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0,0.0,0.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0,0.0,1.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0,0.0,1.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0,0.0,1.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(1.0,0.0,0.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3(0.0,0.0,0.0)*Vector3(_size.x,1.0,_size.z))+Vector3(0.0,y,0.0))*_voxel_scale)
		
		#uv
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
		
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,1.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(0.0,0.0))
		mesh[ArrayMesh.ARRAY_TEX_UV].append(Vector2(1.0,0.0))
	
	var arraymesh : ArrayMesh = ArrayMesh.new()
	arraymesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh)
	arraymesh.surface_set_material(0,material)
	$MeshInstance3D.mesh = arraymesh
