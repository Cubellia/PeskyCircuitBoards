shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;
uniform int pattern : hint_range(0, 2) = 0; // diamond, circle, square
uniform bool inside = false;
uniform bool add_margins = true; // only useful when inside is false

uniform bool flashing =false;
uniform float flashSpeed=1.0;
uniform int start_frame = 0;
uniform int current_frame = 0;
uniform float mix_ratio = 1.0;

const vec3 colors[2 ] = vec3[] (
	vec3(.988,.858,.756), // white
	vec3(0,0,0) // Dark navy

);

void vertex() {
	if (add_margins) {
		VERTEX += (UV * 2.0 - 1.0) * width;
	}
}

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset;
		
		if (pattern == 0) {
			offset = width - abs(x);
		} else if (pattern == 1) {
			offset = floor(sqrt(pow(width + 0.5, 2) - x * x));
		} else if (pattern == 2) {
			offset = width;
		}
		
		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a == 0.0) == inside) {
				return true;
			}
		}
	}
	
	return false;
}
vec3 exclusion(vec3 base, vec3 blend){
	return base + blend - 2.0 * base * blend;
}
vec3 difference(vec3 base, vec3 blend){
	return abs(base - blend);
}

void fragment() {
	vec2 uv = UV;
	
	if (add_margins) {
		vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(width * 2.0));
		
		uv = (uv - texture_pixel_size * width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;
		
		if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
			COLOR.a = 0.0;
		} else {
			COLOR = texture(TEXTURE, uv);
		}
	} else {
		COLOR = texture(TEXTURE, uv);
	}
	
	if ((COLOR.a > 0.0) == inside && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		COLOR.rgb = inside ? mix(COLOR.rgb, color.rgb, color.a) : color.rgb;
		COLOR.a += (1.0 - COLOR.a) * color.a;
	}
	
	//flashy
		// https://en.wikipedia.org/wiki/Rec._709#Luma_coefficients
	float brightness = dot(COLOR.rgb, vec3(0.2126, 0.7152, 0.0722));

	// Calculate the starting frame based on brightness
	int ft = 0;
	if (brightness > 0.75) {
		ft = 2;
	} else if (brightness > 0.25) {
		ft = 1;
	}
	ft =int(TIME*flashSpeed);
	// Get the color, wrapping around at the end of the array
	int color_index = (start_frame + current_frame + ft) % colors.length();
	vec3 acolor = colors[color_index];

	// Apply the color to the sprite
	if (flashing) {COLOR = vec4(difference(COLOR.rgb, acolor), COLOR.a*float(abs(1-color_index)));}
	
}