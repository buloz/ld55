shader_type canvas_item;

uniform float randValue: hint_range(0.0, 1.0);
uniform float touched: hint_range(0.0, 1.0);

void vertex() {
	
	float time = TIME + randValue * -4587.0;
	
	float touchSmoothRatio = pow(touched, 2);
	
	VERTEX.x += (cos(time + touchSmoothRatio * 20.0)) * 100.0 * (1.0 - UV.y);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
