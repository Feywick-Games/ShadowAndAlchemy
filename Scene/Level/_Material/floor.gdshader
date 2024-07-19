shader_type canvas_item;

global uniform sampler2D effect_map : hint_default_white;
global uniform float water_effect_mask;

vec4 color8(vec4 color) {
	return vec4(color.r / 255.0, color.g / 255.0, color.b / 255.0, color.a);
}


void fragment() {
	vec4 map_color = texture(effect_map, UV);
	vec4 color = texture(TEXTURE, UV);
	
	if (map_color.r == 0.0)
	{
		COLOR = color;
	}
	else if (map_color.r <= water_effect_mask )
	{
		COLOR = color8(vec4(66.0,109.0,158.0, 1));
	}
	else
	{
		COLOR = map_color;
	}
}
