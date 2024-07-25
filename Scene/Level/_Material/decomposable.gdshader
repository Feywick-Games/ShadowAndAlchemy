shader_type canvas_item;

global uniform sampler2D effect_map;
global uniform sampler2D reaction_map;
global uniform vec2 level_size;
global uniform float water_effect_mask;
global uniform float fire_effect_mask;

uniform sampler2D fire_noise : hint_default_transparent;
uniform sampler2D platform : hint_default_transparent;
uniform vec2 raised_bottom;
uniform vec4 fire_color_1 : source_color;
uniform vec4 fire_color_2 : source_color;
uniform vec4 fire_color_3 : source_color;
uniform vec4 fire_color_4 : source_color;

varying vec2 global_position;

void vertex() {
	global_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 world_uv = global_position / level_size;
	vec2 world_pixel_size = 1.0 / level_size;
	vec2 image_bottom = world_uv + ((world_pixel_size * vec2(textureSize(TEXTURE,0))) * (vec2(1)-UV)) - (raised_bottom * world_pixel_size);
	image_bottom.x = world_uv.x;
	vec4 d_col = texture(reaction_map, world_uv);

	vec4 d_col_1 = texture(reaction_map, mix(world_uv, image_bottom,.1));
	vec4 d_col_2 = texture(reaction_map, mix(world_uv, image_bottom,.2));
	vec4 d_col_3 = texture(reaction_map, mix(world_uv, image_bottom,.3));
	vec4 d_col_4 = texture(reaction_map, mix(world_uv, image_bottom,.4));
	vec4 d_col_5 = texture(reaction_map, mix(world_uv, image_bottom,.5));
	vec4 d_col_6 = texture(reaction_map, mix(world_uv, image_bottom,.6));
	vec4 d_col_7 = texture(reaction_map, mix(world_uv, image_bottom,.7));
	vec4 d_col_8 = texture(reaction_map, mix(world_uv, image_bottom,.8));
	vec4 d_col_9 = texture(reaction_map, mix(world_uv, image_bottom,.9));
	vec4 d_col_10 = texture(reaction_map, mix(world_uv, image_bottom, .95));
	vec4 d_col_11 = texture(reaction_map, mix(world_uv, image_bottom, .98));
	vec4 d_col_12 = texture(reaction_map, mix(world_uv, image_bottom,.1));

	vec4 t_col = texture(TEXTURE,UV);
	vec4 p_col = texture(platform, UV);
	
	bool neighbor_disintegrated = (
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
	
	vec4 e_col_1 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,12) * (1.0-UV.y)));
	vec4 e_col_2 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,16)* (1.0-UV.y)));
	vec4 e_col_3 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,20)* (1.0-UV.y)));
	vec4 e_col_4 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,24)* (1.0-UV.y)));
	vec4 e_col_5 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,28)* (1.0-UV.y)));
	vec4 e_col_6 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,32)* (1.0-UV.y)));
	vec4 e_col_7 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,40)* (1.0-UV.y)));
	vec4 e_col_8 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,44)* (1.0-UV.y)));
	vec4 e_col_9 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,48))* (1.0-UV.y));
	vec4 e_col_10 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,52)* (1.0-UV.y)));
	vec4 e_col_11 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,54)* (1.0-UV.y)));
	vec4 e_col_12 = texture(effect_map, world_uv + (world_pixel_size * vec2(0,60)* (1.0-UV.y)));

	bool neighbor_fire = (
		e_col_1.r > water_effect_mask && e_col_1.r <= fire_effect_mask ||
		e_col_2.r > water_effect_mask && e_col_2.r <= fire_effect_mask ||
		e_col_3.r > water_effect_mask && e_col_3.r <= fire_effect_mask ||
		e_col_4.r > water_effect_mask && e_col_4.r <= fire_effect_mask ||
		e_col_5.r > water_effect_mask && e_col_5.r <= fire_effect_mask ||
		e_col_6.r > water_effect_mask && e_col_6.r <= fire_effect_mask ||
		e_col_7.r > water_effect_mask && e_col_7.r <= fire_effect_mask ||
		e_col_8.r > water_effect_mask && e_col_8.r <= fire_effect_mask ||
		e_col_9.r > water_effect_mask && e_col_9.r <= fire_effect_mask ||
		e_col_10.r > water_effect_mask && e_col_10.r <= fire_effect_mask ||
		e_col_11.r > water_effect_mask && e_col_11.r <= fire_effect_mask ||
		e_col_12.r > water_effect_mask && e_col_12.r <= fire_effect_mask
	);


	if (d_col.b > 0.0) {
		COLOR = vec4(0);
	}
	else if (neighbor_disintegrated)
	{
		COLOR = p_col;
	}
	else if (neighbor_fire && (t_col.a > 0.0 || p_col.a > 0.0))
	{
		vec4 map_color_d = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));
		vec4 map_color_u = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-1))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));
		vec4 map_color_l = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(-1,0))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));
		vec4 map_color_r = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(1,0))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));

		vec4 map_color_d2 = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,2))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));
		vec4 map_color_u2 = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-2))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));
		vec4 map_color_l2 = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(-2,0))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));
		vec4 map_color_r2 = max(texture(TEXTURE, UV + (TEXTURE_PIXEL_SIZE * vec2(2,0))), texture(platform, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1))));

		bool time_is_even = (int(TIME) % 2 == 0);
		bool is_even = (int((UV * (1.0 / TEXTURE_PIXEL_SIZE)).x) % 2 == 0);
		bool is_outline = !(map_color_u.a < 0.0) && (
		(map_color_d.a  < 0.0) ||
		(map_color_l.a  < 0.0) ||
		(map_color_r.a   < 0.0));
		bool is_outline2 = !(map_color_u2.r  < 0.0) && (
		(map_color_d2.a  < 0.0) ||
		(map_color_l2.a  < 0.0) ||
		(map_color_r2.a  < 0.0));

		bool is_top = (texture(TEXTURE, UV + TEXTURE_PIXEL_SIZE * (vec2(0,1))).a == 0.0);

		float time_scale2 = TIME * (1.0 / level_size.x) * 30.0;
		vec4 direction_color = texture(fire_noise, world_uv + time_scale2);
		float theta = direction_color.r * TAU;
		vec2 uv_offset = mat2(vec2(cos(theta), sin(theta)), vec2(-sin(theta), cos(theta))) * vec2(0,(1.0 / level_size.x) * 1.5);
		float time_scale = (TIME * (1.0 / level_size.x));
		vec4 noise_color = texture(fire_noise, (uv_offset + vec2(world_uv.x * 2.0, world_uv.y)));

		//if (map_color.r < fire_effect_mask - .05)
		//{
			//noise_color.r -= .1;
		//}
		//
		//if (flame_exception)
		//{
			////noise_color.r -= .1;
			//noise_color.r = clamp(noise_color.r, .35, 1);
		//}
		//
		if (is_outline || is_outline2)
		{
			noise_color.r -= .1 + (float(int(sin(TIME) * 1000.0) % 2000) / 20000.0);
		}
		//else if (is_top)
		//{
			//noise_color.r = .4;
		//}
		//else
		{
			if (noise_color.r < .3){
				COLOR = t_col;
			}
			else if (noise_color.r < .4){
				COLOR = mix(t_col, fire_color_4, .75);
			}
			else if (noise_color.r < .6) {
				COLOR = fire_color_4;
			}
			else if (noise_color.r < 0.7)
			{
				COLOR = fire_color_1;
			}
			else if (noise_color.r < .8)
			{
				COLOR = fire_color_2;
			}
			else
			{
				COLOR = fire_color_3;
			}
		}
	}
	else if (t_col.a == 0.0 && p_col.a > 0.0)
	{
		COLOR = p_col;
	}
	else
	{
		COLOR = t_col;
	}
	
}
