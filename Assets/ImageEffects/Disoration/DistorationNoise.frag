// Author:
// Title:

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
    vec2 n, q;
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
	mat2 m = mat2(1.0, sin(u_time)/2., 
                  cos(u_time)/2.0, 1.0);
    vec2 u = st - .5;
    float d = dot(u,u), s = 9.0, t = u_time, o;
    for	(float j = 0.0; j < 2.0; j++){
        u = m *u;
        n = m * n;
        q = u * s + t * 4.0 + sin(t * 2.0 - d * 6.0) * 10.0 + j + n;
        o += dot(cos(q) / s, vec2(2.,2.));
        n -= sin(q);
        s *= 0.576;
    }
    gl_FragColor = vec4(0.916,0.579,1.000,1.000) * o;
}