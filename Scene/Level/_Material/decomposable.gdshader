shader_type canvas_item;

global uniform sampler2D effect_map;
global uniform sampler2D reaction_map;
global uniform vec2 level_size;

varying vec2 global_position;

void vertex() {
	global_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 world_uv = global_position / level_size;
	vec2 world_pixel_size = 1.0 / level_size;
	vec4 d_col = texture(reaction_map, world_uv);

	vec4 d_col_1 = texture(reaction_map, world_uv + (world_pixel_size * vec2(1,1)));
	vec4 d_col_2 = texture(reaction_map, world_uv + (world_pixel_size * vec2(0,1)));
	vec4 d_col_3 = texture(reaction_map, world_uv + (world_pixel_size * vec2(1,0)));
	vec4 d_col_4 = texture(reaction_map, world_uv + (world_pixel_size * vec2(-1,1)));
	vec4 d_col_5 = texture(reaction_map, world_uv + (world_pixel_size * vec2(0,-1)));
	vec4 d_col_6 = texture(reaction_map, world_uv + (world_pixel_size * vec2(-1,-1)));
	vec4 d_col_7 = texture(reaction_map, world_uv + (world_pixel_size * vec2(-1,0)));
	vec4 d_col_8 = texture(reaction_map, world_uv + (world_pixel_size * vec2(1,-1)));
	vec4 d_col_9 = texture(reaction_map, world_uv + (world_pixel_size * vec2(2,0)));
	vec4 d_col_10 = texture(reaction_map, world_uv + (world_pixel_size * vec2(0,2)));
	vec4 d_col_11 = texture(reaction_map, world_uv + (world_pixel_size * vec2(-2,0)));
	vec4 d_col_12 = texture(reaction_map, world_uv + (world_pixel_size * vec2(0,-2)));


	vec4 col_1 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(1,1)));
	vec4 col_2 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1)));
	vec4 col_3 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(1,0)));
	vec4 col_4 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(-1,1)));
	vec4 col_5 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-1)));
	vec4 col_6 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(-1,-1)));
	vec4 col_7 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(-1,0)));
	vec4 col_8 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(1,-1)));
	vec4 col_9 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(2,0)));
	vec4 col_10 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,2)));
	vec4 col_11 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(-2,0)));
	vec4 col_12 = texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-2)));

	bool neighbor_disintgrated = (
		d_col_1.b > 0.0 ||
		d_col_2.b > 0.0 ||
		d_col_3.b > 0.0 ||
		d_col_4.b > 0.0 ||
		d_col_5.b > 0.0 ||
		d_col_6.b > 0.0 ||
		d_col_7.b > 0.0 ||
		d_col_8.b > 0.0 ||
		d_col_9.b > 0.0 ||
		d_col_10.b > 0.0 ||
		d_col_11.b > 0.0 ||
		d_col_12.b > 0.0
	);


	if (d_col.b > 0.0) {
		COLOR = vec4(0);
	}
	else if (!neighbor_disintgrated)
	{
		COLOR = texture(TEXTURE, UV);
	}
	else if (d_col_12.b > 0.0)
	{
		COLOR = col_12;
	}
	else if (d_col_11.b > 0.0)
	{
		COLOR = col_11;
	}
	else if (d_col_10.b > 0.0)
	{
		COLOR = col_10;
	}
	else if (d_col_9.b > 0.0)
	{
		COLOR = col_9;
	}
	else if (d_col_8.b > 0.0)
	{
		COLOR = col_8;
	}
	else if (d_col_7.b > 0.0)
	{
		COLOR = col_7;
	}
	else if (d_col_6.b > 0.0)
	{
		COLOR = col_6;
	}
	else if (d_col_5.b > 0.0)
	{
		COLOR = col_5;
	}
	else if (d_col_4.b > 0.0)
	{
		COLOR = col_4;
	}
	else if (d_col_3.b > 0.0)
	{
		COLOR = col_3;
	}
	else if (d_col_2.b > 0.0)
	{
		COLOR = col_2;
	}
	else if (d_col_1.b > 0.0)
	{
		COLOR = col_1;
	}
}
