shader_type canvas_item;

uniform float current: hint_range(0.0, 1.0, 1.0) = 0.0;

void vertex() {

	float alpha = pow(cos(TIME), 2.0) * 0.25 * current;
	
	VERTEX.x *= 1.0 + alpha;
	VERTEX.y *= 1.0 + alpha;
}

uniform float test: hint_range(-4.0, 4.0);

void fragment() {
	
	vec2 uv = UV;
	vec2 center = (UV * 2.0) - 1.0;
	
	float time = TIME * 1.0 * current;
	float alphaX = (cos(time * 2.0 + PI) + 1.0) * 0.5;
	float alphaY = sin(time);

	
	float xRotate = center.x * (alphaY);
	
	uv.x += alphaX * (uv.x * 2.0 - 1.0) * 0.25;
	uv.y += (xRotate * center.y) * 0.125;
	
	COLOR = texture(TEXTURE, uv);
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
