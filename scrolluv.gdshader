shader_type canvas_item;

uniform sampler2D inverter:filter_nearest;

uniform vec2 motion = vec2(0.0);
uniform float scale = 1.0;
uniform vec2 offset = vec2(0.0);
uniform float contrast : hint_range(0, 3) = 1.0;
uniform float brightness : hint_range(-1, 1) = 0;
uniform float graylight =0.01;
mat4 contrastMatrix( float _contrast ){
	float t = ( 1.0 - _contrast ) / 2.0;
    return mat4( 
		vec4(_contrast, 0, 0, 0),
		vec4(0, _contrast, 0, 0),
		vec4(0, 0, _contrast, 0),
		vec4(t, t, t, 1));
}
mat4 brightnessMatrix( float _brightness ){
    return mat4( vec4(1, 0, 0, 0),
                 vec4(0, 1, 0, 0),
                 vec4(0, 0, 1, 0),
                 vec4(_brightness, _brightness, _brightness, 1));
}
void vertex(){
	UV = (VERTEX + offset + TIME * motion) * TEXTURE_PIXEL_SIZE * (1.0/scale);
}

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	vec4 gradt = texture(inverter,SCREEN_UV);
	COLOR = vec4(abs(color.rgb-gradt.rgb), color.a) *brightnessMatrix( brightness ) * contrastMatrix( contrast )+graylight;
}
