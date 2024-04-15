shader_type canvas_item;

uniform float screenLoadScale: hint_range(0.0, 1.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


void fragment() {
	ivec2 size = textureSize(screen_texture, 0);
	vec2 center = (SCREEN_UV * 2.0 - 1.0);
	float xRatio = float(size.x) / float(size.y);

	center.x *= xRatio;


	
	COLOR.rbg = vec3(0.0);
	if ( screenLoadScale != 1.0 && length(center) > sin(screenLoadScale * PI / 2.0) * (xRatio * 1.4) ) {
		COLOR.a =  1.0;
	}
	else {
		COLOR.a = 0.0;
	}
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
