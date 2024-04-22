shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	COLOR.rgb *= 1.65;
	
	vec2 center = UV * 2.0 - 1.0;
	float dist = 1.5 - length(center * 2.0);
	COLOR.a = max(dist, 0.0) * COLOR.a;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
