shader_type spatial;

const int chunk_length = 256;
const int chunk_length_squared = 65536;
const int chunk_length_cubed = 16777216;

uniform sampler2DArray textures;
uniform int data[16777216]; // a lot of data, will compressed down to 16 bits since the textures are limited to 2048 indexes

void fragment() {
	vec2 uv = UV*256.0f;
	vec4 color = vec4(0.0f,0.0f,0.0f,0.0f);
	
	/*for ( int x = chunk_length_squared ; x != 0; x--)
	{
		int value = data[x];
		if (value != 0)
			color = texture(textures, vec3(UV,float(value-1)));
	}*/
	
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
