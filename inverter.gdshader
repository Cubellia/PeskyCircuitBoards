shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture,filter_nearest;

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

void fragment(){
    
    vec4 color = vec4(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, texture(TEXTURE, UV).a);
    vec4 cc = vec4(1.0 - color.rgb,  color.a)*brightnessMatrix( brightness ) * contrastMatrix( contrast )+graylight;
    COLOR = vec4(cc.rgb,cc.a);
}