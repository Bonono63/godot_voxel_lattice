class_name ChunkData
extends Resource

const chunk_length = 256
const chunk_length_squared = 65536
const chunk_length_cubed = 16777216

var data : PackedInt32Array = PackedInt32Array()


func _init() -> void:
	data.resize(chunk_length_cubed)
	data.fill(0)

func get_index(index : int) -> int:
	return data[index]

func set_index(index : int, value : int) -> void:
	data[index] = value

func set_index_v(pos : Vector3i, value : int):
	var index = pos.x+(pos.z*chunk_length)+(pos.y*chunk_length_squared)
	data[index] = value
