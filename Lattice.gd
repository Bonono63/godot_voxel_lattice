@tool
extends Node3D

var data : ChunkData = ChunkData.new()
var size : Vector3i
var voxel_scale : float
var textures : Texture2DArray = Texture2DArray.new()
var material : ShaderMaterial = ShaderMaterial.new()

func _init(_size : Vector3i = Vector3i(256,256,256), _voxel_scale : float = 1.0):
	size = _size
	voxel_scale = _voxel_scale
	
	var pathes : Array[String] = ["resources/assets/minecraft/textures/block/dirt.png"]
	var temp : Array[Image] = []
	
	for texture in pathes:
		var image : Image = Image.load_from_file("res://"+texture)
		temp.append(image)
	
	textures.create_from_images(temp)
	
	for x in ChunkData.chunk_length:
		for z in ChunkData.chunk_length:
			data.set_index_v(Vector3i(x,2,z), 1)
	
	material.shader = load("res://lattice.gdshader")
	material.set_shader_parameter("textures",textures)
	material.set_shader_parameter("data",data.data)

func _ready():
	create_lattice_mesh(size, voxel_scale)

func create_lattice_mesh(_size : Vector3i, _voxel_scale : int) -> void:
	var mesh : Array = []
	mesh.resize(ArrayMesh.ARRAY_MAX)
	mesh[ArrayMesh.ARRAY_VERTEX] = PackedVector3Array()
	
	# Positive X
	for x in _size.z:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0, 1.0, 1.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0, 0.0, 1.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 1.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 1.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 1.0, 1.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0, 1.0, 1.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
	
	# Negative X
	for x in _size.z:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i( 0.0, 0.0, 0.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0, 0.0, 0.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0, 1.0, 0.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0, 1.0, 0.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i( 0.0, 1.0, 0.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i( 0.0, 0.0, 0.0)*Vector3i(_size.x, _size.y, 1.0))+Vector3i(0.0,0.0,x))*_voxel_scale)
	
	# Positive Z
	for z in _size.x:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 0.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 1.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 1.0, 1.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z+1,0.0,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 1.0, 1.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 1.0, 0.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z+1,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 0.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z+1,0.0,0.0))*_voxel_scale)
	
	# Negative Z
	for z in _size.x:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 1.0, 1.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 1.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 0.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z,0.0,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 0.0, 0.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 1.0, 0.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z,0.0,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0, 1.0, 1.0)*Vector3i(1.0, _size.y, _size.z))+Vector3i(z,0.0,0.0))*_voxel_scale)
	
	# Positive Y
	for y in _size.y:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0,1.0,1.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0,1.0,1.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0,1.0,0.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0,1.0,0.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0,1.0,0.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0,1.0,1.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
	
	for y in _size.y:
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0,0.0,0.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0,0.0,1.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0,0.0,1.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0,0.0,1.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(1.0,0.0,0.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
		mesh[ArrayMesh.ARRAY_VERTEX].append(((Vector3i(0.0,0.0,0.0)*Vector3i(_size.x,1.0,_size.z))+Vector3i(0.0,y,0.0))*_voxel_scale)
	
	var arraymesh : ArrayMesh = ArrayMesh.new()
	arraymesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh)
	arraymesh.surface_set_material(0,material)
	$MeshInstance3D.mesh = arraymesh
