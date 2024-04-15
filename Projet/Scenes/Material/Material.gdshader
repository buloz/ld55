shader_type canvas_item;

varying flat vec4 regionInfo;

uniform float col;
uniform float row;

varying vec2 pos;

void vertex() {
	
	float timeRatio = pow(cos(TIME), 2.0);
	
	float ratio = 0.86;
	float inverseRatio = 1.0 - ratio;
	
	pos = vec2(VERTEX.x, VERTEX.y);
	
	VERTEX.x *= ratio + timeRatio * inverseRatio;
	VERTEX.y *= ratio + timeRatio * inverseRatio;
	
	
}

vec2 getTrueUv() {
	float diffValue = 300.0;
	return pos / diffValue + 0.5;
}

void fragment() {
	
	vec2 uv = getTrueUv();
	
	vec2 size = vec2(textureSize(TEXTURE, 0));
	
	float timeRatio = pow(cos(TIME), 2.0);
	
	if (COLOR.a == 0.0) {
		
		
		
		float dist = length(uv * 2.0 - 1.0) * 1.2;
		COLOR.rgb += vec3(1.5);
		
		vec2 center = uv * 2.0 - 1.0;
		float angle = atan(center.y,center.x);

		float angleStep = 0.5;
		if (mod((abs(angle) * 1.0 + TIME * 1.0), angleStep) > angleStep * 0.5) {
			COLOR.a = 3.0;
		}

		
		COLOR.a *= (1.0-dist) * 1.0;
		
		//COLOR.rgb = vec3(uv.x, uv.y, 0.0);
		
		
	}
	
	//float dist = length(uv * 2.0 - 1.0);
	

	//COLOR.rgb = vec3(uv.x, uv.y, 0.0);
	//COLOR.a = 1.0;
	
	//COLOR.rgb = vec3(1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
