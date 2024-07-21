shader_type canvas_item;

global uniform sampler2D effect_map : filter_nearest;
uniform vec2 previous_position;
uniform vec2 new_position;
uniform float intensity=1.0;
uniform float freq = 1.0;
//
//void vertex() {
	////float d = dot(normalize(new_position - previous_position),normalize(VERTEX));
	//if (VERTEX.y < 0.0)
	//{
		//VERTEX.y = -VERTEX.y * .1;
	//}
//}

void fragment(){
	vec4 col = texture(effect_map, UV);
	//col.a = 1.0;
	////col.r = 0.0;
	COLOR = col;
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
