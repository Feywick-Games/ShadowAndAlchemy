shader_type canvas_item;

global uniform sampler2D effect_map : hint_default_black;
global uniform float water_effect_mask;
global uniform sampler2D reaction_map : hint_default_black;
uniform vec4 water_color_1 : source_color;
uniform vec4 water_color_2 : source_color;
uniform vec4 electric_color_1 : source_color;
uniform vec4 electric_color_2 : source_color;
uniform vec4 white_color : source_color;

uniform sampler2D water_noise;
uniform sampler2D electric_noise;


vec4 color8(vec4 color) {
	return vec4(color.r / 255.0, color.g / 255.0, color.b / 255.0, color.a);
}


void fragment() {
	vec4 map_color = texture(effect_map, UV);
	vec4 reaction_color = texture(reaction_map, UV);
	vec4 color = texture(TEXTURE, UV);
	
	if (map_color.r == 0.0 && reaction_color.g == 0.0)
	{
		COLOR = color;
	}
	else if (map_color.r <= water_effect_mask && reaction_color.g == 0.0)
	{
		vec4 map_color_u = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1)));
		vec4 map_color_d = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-1)));
		vec4 map_color_l = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(-1,0)));
		vec4 map_color_r = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(1,0)));
		
		vec4 map_color_u2 = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,2)));
		vec4 map_color_d2 = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-2)));
		vec4 map_color_l2 = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(-2,0)));
		vec4 map_color_r2 = texture(effect_map, UV + (TEXTURE_PIXEL_SIZE * vec2(2,0)));
		
		bool time_is_even = (int(TIME * 2.0) % 2 == 0);
		bool is_even = (int((UV * (1.0 / TEXTURE_PIXEL_SIZE)).x) % 2 == 0);
		bool is_outline = (map_color_u.r == 0.0 || 
		map_color_d.r == 0.0 || 
		map_color_l.r == 0.0 || 
		map_color_r.r == 0.0);
		bool is_outline2 = (map_color_u2.r == 0.0 || 
		map_color_d2.r == 0.0 || 
		map_color_l2.r == 0.0 || 
		map_color_r2.r == 0.0);
		
		if (is_outline || (time_is_even && is_even && is_outline2) || (!time_is_even && !is_even  && is_outline2))
		{
			COLOR = mix(color, white_color, .5);
		}
		else
		{
			float time_scale = sin(TIME);
			vec4 noise_color = texture(water_noise, UV + (TEXTURE_PIXEL_SIZE * time_scale));
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
	
	else if (reaction_color.g > 0.0) {

		vec4 map_color_u = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,1)));
		vec4 map_color_d = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-1)));
		vec4 map_color_l = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(-1,0)));
		vec4 map_color_r = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(1,0)));
		
		vec4 map_color_u2 = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,2)));
		vec4 map_color_d2 = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(0,-2)));
		vec4 map_color_l2 = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(-2,0)));
		vec4 map_color_r2 = texture(reaction_map, UV + (TEXTURE_PIXEL_SIZE * vec2(2,0)));
		
		bool time_is_even = (int(TIME * 2.0) % 2 == 0);
		bool is_even = (int((UV * (1.0 / TEXTURE_PIXEL_SIZE)).x) % 2 == 0);
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
			vec4 noise_color = texture(electric_noise, UV + (TEXTURE_PIXEL_SIZE * time_scale));
			if (noise_color.r < 0.5)
			{
				COLOR = electric_color_1;
			}
			else
			{
				COLOR = electric_color_2;
			}
		}	}
}
