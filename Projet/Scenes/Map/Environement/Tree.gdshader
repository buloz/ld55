shader_type canvas_item;

uniform float randValue: hint_range(0.0, 1.0);
uniform float touched: hint_range(0.0, 1.0);

void vertex() {
	
}

void fragment() {
	
	vec2 uv = UV;
	
	float time = TIME + randValue * -4587.0;
	
	float touchSmoothRatio = pow(touched, 2);
	
	uv.x += (cos(time + touchSmoothRatio * 20.0)) * 1.0 * pow(1.0 - uv.y, 3.0) * 0.05;
	
	COLOR = texture(TEXTURE, uv);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
