shader_type canvas_item;

uniform vec2 time_scale = vec2(1.0, 1.0);
uniform vec2 offset_scale = vec2(1.0, 1.0);
uniform vec2 amplitude = vec2(1, 1);

void fragment() {
	vec2 tiled_uvs = UV * vec2(1, 1);
	
	vec2 waves_uv_offset;
	waves_uv_offset.x = cos(TIME * time_scale.x + (tiled_uvs.x + tiled_uvs.y) * offset_scale.x) * 0.05;
	waves_uv_offset.y = sin(TIME * time_scale.y + (tiled_uvs.x + tiled_uvs.y) * offset_scale.y) * 0.05;
	COLOR = texture( TEXTURE, tiled_uvs + waves_uv_offset * amplitude);
	
	
//	COLOR = vec4(tiled_uvs, 0.0, 1.0);
}
