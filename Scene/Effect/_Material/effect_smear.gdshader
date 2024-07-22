shader_type canvas_item;

global uniform sampler2D effect_map : filter_nearest;
uniform vec2 direction = vec2(1,0);
uniform float intensity=1.0;
uniform float freq = 1.0;


void fragment(){
	vec4 col = texture(effect_map, UV);
	COLOR = col;
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
