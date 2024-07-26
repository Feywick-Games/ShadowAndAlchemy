shader_type canvas_item;

global uniform sampler2D effect_map : hint_default_black;
global uniform float water_effect_mask;
global uniform float fire_effect_mask;
global uniform sampler2D reaction_map : hint_default_black;
global uniform vec2 level_size;
uniform vec4 water_color_1 : source_color;
uniform vec4 water_color_2 : source_color;
uniform vec4 electric_color_1 : source_color;
uniform vec4 electric_color_2 : source_color;
uniform vec4 white_color : source_color;
uniform vec4 fire_color_1 : source_color;
uniform vec4 fire_color_2 : source_color;
uniform vec4 fire_color_3 : source_color;
uniform vec4 fire_color_4 : source_color;

uniform sampler2D water_noise;
uniform sampler2D electric_noise;
uniform sampler2D fire_noise : repeat_enable;

vec4 color8(vec4 color) {
	return vec4(color.r / 255.0, color.g / 255.0, color.b / 255.0, color.a);
}


void fragment() {
	vec2 world_uv = ((1.0 / TEXTURE_PIXEL_SIZE) / level_size) * UV;
	vec4 map_color = texture(effect_map, world_uv);
	vec4 reaction_color = texture(reaction_map, world_uv);
	vec4 color = texture(TEXTURE, UV);

	vec4 map_color_d1 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,1)));
	vec4 map_color_d2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,2)));
	vec4 map_color_d3 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,3)));
	vec4 map_color_d4 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,4)));
	vec4 map_color_d5 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,5)));
	vec4 map_color_d6 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,6)));
	vec4 map_color_d7 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,7)));
	vec4 map_color_d8 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,8)));
	vec4 map_color_d9 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,9)));
	vec4 map_color_d10 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,10)));

	bool flame_exception = !(map_color.r > water_effect_mask && map_color.r < fire_effect_mask) && (
	(map_color_d1.r > water_effect_mask && map_color_d1.r <= fire_effect_mask) ||
	(map_color_d2.r > water_effect_mask && map_color_d2.r <= fire_effect_mask) ||
	(map_color_d3.r > water_effect_mask && map_color_d3.r <= fire_effect_mask) ||
	(map_color_d4.r > water_effect_mask && map_color_d4.r <= fire_effect_mask) ||
	(map_color_d5.r > water_effect_mask && map_color_d5.r <= fire_effect_mask) ||
	(map_color_d6.r > water_effect_mask && map_color_d6.r <= fire_effect_mask) ||
	(map_color_d2.r > water_effect_mask && map_color_d7.r <= fire_effect_mask) ||
	(map_color_d3.r > water_effect_mask && map_color_d8.r <= fire_effect_mask) ||
	(map_color_d4.r > water_effect_mask && map_color_d9.r <= fire_effect_mask) ||
	(map_color_d5.r > water_effect_mask && map_color_d10.r <= fire_effect_mask)
	)
	;

	float time_scale2 = TIME * TEXTURE_PIXEL_SIZE.x * 30.0;
	vec4 direction_color = texture(fire_noise, world_uv + time_scale2);
	float theta = direction_color.r * TAU;
	vec2 world_uv_offset = mat2(vec2(cos(theta), sin(theta)), vec2(-sin(theta), cos(theta))) * vec2(0,TEXTURE_PIXEL_SIZE.x * 1.5);
	float time_scale = (TIME * TEXTURE_PIXEL_SIZE.x);
	vec4 flame_noise_color = texture(fire_noise, (world_uv_offset + vec2(world_uv.x * 2.0, world_uv.y)));

	if (flame_noise_color.r > .5) {
		flame_exception = false;
	}

	if (map_color.r == 0.0 && reaction_color.g == 0.0 && !flame_exception)
	{
		COLOR = color;
	}
	else if (map_color.r <= water_effect_mask && reaction_color.g == 0.0 && !flame_exception)
	{
		vec4 map_color_u = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,1)));
		vec4 map_color_d = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,-1)));
		vec4 map_color_l = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(-1,0)));
		vec4 map_color_r = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(1,0)));

		vec4 map_color_u2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,2)));
		vec4 map_color_d2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,-2)));
		vec4 map_color_l2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(-2,0)));
		vec4 map_color_r2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(2,0)));

		bool time_is_even = (int(TIME * 2.0) % 2 == 0);
		bool is_even = (int((world_uv * (1.0 / TEXTURE_PIXEL_SIZE)).x) % 2 == 0);
		bool is_outline = ((map_color_u.r == 0.0 || map_color_u.r >= water_effect_mask)||
		(map_color_d.r == 0.0 || map_color_d.r > water_effect_mask) ||
		(map_color_l.r == 0.0 || map_color_l.r > water_effect_mask) ||
		(map_color_r.r == 0.0 || map_color_r.r > water_effect_mask));
		bool is_outline2 = ((map_color_u2.r == 0.0 && map_color_u2.r <= water_effect_mask)||
		(map_color_d2.r == 0.0 || map_color_d2.r > water_effect_mask) ||
		(map_color_l2.r == 0.0 || map_color_l2.r > water_effect_mask) ||
		(map_color_r2.r == 0.0 || map_color_r2.r > water_effect_mask));

		if (is_outline || (time_is_even && is_even && is_outline2) || (!time_is_even && !is_even  && is_outline2))
		{
			COLOR = mix(color, white_color, .5);
		}
		else
		{
			float time_scale = sin(TIME);
			vec4 noise_color = texture(water_noise, world_uv + (TEXTURE_PIXEL_SIZE * time_scale));
			if (noise_color.r < 0.5)
			{
				COLOR = mix(water_color_1,color, 0.4);
			}
			else
			{
				COLOR = mix(water_color_2, color, 0.4);
			}
		}
	}

	else if (map_color.r <= fire_effect_mask && reaction_color.g == 0.0  || flame_exception) {

		vec4 map_color_d = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,1)));
		vec4 map_color_u = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,-1)));
		vec4 map_color_l = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(-1,0)));
		vec4 map_color_r = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(1,0)));

		vec4 map_color_d2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,2)));
		vec4 map_color_u2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,-2)));
		vec4 map_color_l2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(-2,0)));
		vec4 map_color_r2 = texture(effect_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(2,0)));

		bool time_is_even = (int(TIME) % 2 == 0);
		bool is_even = (int((world_uv * (1.0 / TEXTURE_PIXEL_SIZE)).x) % 2 == 0);
		bool is_outline = !(map_color_u.r  <= water_effect_mask || map_color_u.r > fire_effect_mask) && (
		(map_color_d.r  <= water_effect_mask ||  map_color_d.r  > fire_effect_mask) ||
		(map_color_l.r  <= water_effect_mask ||  map_color_l.r  > fire_effect_mask) ||
		(map_color_r.r  <= water_effect_mask ||  map_color_r.r  > fire_effect_mask));
		bool is_outline2 = !(map_color_u2.r < water_effect_mask || map_color_u2.r > fire_effect_mask) && (
		(map_color_d2.r  <= water_effect_mask ||  map_color_d2.r  > fire_effect_mask) ||
		(map_color_l2.r  <= water_effect_mask ||  map_color_l2.r  > fire_effect_mask) ||
		(map_color_r2.r  <= water_effect_mask ||  map_color_r2.r  > fire_effect_mask));

		bool is_top = (map_color_u.r  <= water_effect_mask || map_color_u.r > fire_effect_mask) &&
		!(map_color.r > water_effect_mask && map_color.r < fire_effect_mask) && (
		(map_color_d1.r > water_effect_mask && map_color_d1.r <= fire_effect_mask) ||
		(map_color_d2.r > water_effect_mask && map_color_d2.r <= fire_effect_mask) ||
		(map_color_d3.r > water_effect_mask && map_color_d3.r <= fire_effect_mask) ||
		(map_color_d4.r > water_effect_mask && map_color_d4.r <= fire_effect_mask) ||
		(map_color_d5.r > water_effect_mask && map_color_d5.r <= fire_effect_mask) ||
		(map_color_d6.r > water_effect_mask && map_color_d6.r <= fire_effect_mask) ||
		(map_color_d2.r > water_effect_mask && map_color_d7.r <= fire_effect_mask) ||
		(map_color_d3.r > water_effect_mask && map_color_d8.r <= fire_effect_mask) ||
		(map_color_d4.r > water_effect_mask && map_color_d9.r <= fire_effect_mask)
		);

		float time_scale2 = TIME * (1.0/level_size.x) * 30.0;
		vec4 direction_color = texture(fire_noise, world_uv + time_scale2);
		float theta = direction_color.r * TAU;
		vec2 world_uv_offset = mat2(vec2(cos(theta), sin(theta)), vec2(-sin(theta), cos(theta))) * vec2(0,(1.0/level_size.x) * 2.0);
		float time_scale = (TIME *  (1.0/level_size.x));
		vec4 noise_color = texture(fire_noise, (world_uv_offset + vec2(world_uv.x, world_uv.y)));

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
			if (noise_color.r < .2){
				COLOR = color;
			}
			else if (noise_color.r < .35){
				COLOR = mix(color, fire_color_4, .75);
			}
			else if (noise_color.r < .5) {
				COLOR = fire_color_4;
			}
			else if (noise_color.r < 0.65)
			{
				COLOR = fire_color_1;
			}
			else if (noise_color.r < .75)
			{
				COLOR = fire_color_2;
			}
			else
			{
				COLOR = fire_color_3;
			}
		}
	}
	else if (reaction_color.g > 0.0) {

		vec4 map_color_u = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,1)));
		vec4 map_color_d = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,-1)));
		vec4 map_color_l = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(-1,0)));
		vec4 map_color_r = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(1,0)));

		vec4 map_color_u2 = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,2)));
		vec4 map_color_d2 = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(0,-2)));
		vec4 map_color_l2 = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(-2,0)));
		vec4 map_color_r2 = texture(reaction_map, world_uv + (TEXTURE_PIXEL_SIZE * vec2(2,0)));

		bool time_is_even = (int(TIME * 2.0) % 2 == 0);
		bool is_even = (int((world_uv * (1.0 / TEXTURE_PIXEL_SIZE)).x) % 2 == 0);
		bool is_outline = (map_color_u.g == 0.0 ||
		map_color_d.g == 0.0 ||
		map_color_l.g == 0.0 ||
		map_color_r.g == 0.0);
		bool is_outline2 = (map_color_u2.g == 0.0 ||
		map_color_d2.g == 0.0 ||
		map_color_l2.g == 0.0 ||
		map_color_r2.g == 0.0);

		if (is_outline || (time_is_even && is_even && is_outline2) || (!time_is_even && !is_even  && is_outline2))
		{
			COLOR = white_color;
		}
		else
		{
			float time_scale = sin(TIME * 10.0);
			vec4 noise_color = texture(electric_noise, world_uv + (TEXTURE_PIXEL_SIZE * time_scale));
			if (noise_color.r < 0.5)
			{
				COLOR = electric_color_1;
			}
			else
			{
				COLOR = electric_color_2;
			}
		}
	}
}
