//
//  shders2.metal
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 18.06.24.
//


#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


//#define M_2_PI 6.28318530
//#define M_PI 3.14159265
//#define SCALE .9
//#define SPEED 0.2
//#define POINTS 35.0
//#define LENGTH 0.06
//#define RADIUS 0.03
//#define FADING 0.15
//#define GLOW 1.3

#define M_2_PI 6.28318530

#define SCALE .3
#define SPEED 0.05
#define POINTS 35.0
#define LENGTH 0.05
#define RADIUS 0.02
#define FADING 0.5
#define GLOW 1.3

float2 sdBezierRect(float2 pos, float2 A, float2 B, float2 C)
{
    float2 a = B - A;
    float2 b = A - 2.0 * B + C;
    float2 c = a * 2.0;
    float2 d = A - pos;

    float kk = 1.0 / dot(b, b);
    float kx = kk * dot(a, b);
    float ky = kk * (2.0 * dot(a, a) + dot(d, b)) / 3.0;
    float kz = kk * dot(d, a);

    float p = ky - kx * kx;
    float p3 = p * p * p;
    float q = kx * (2.0 * kx * kx - 3.0 * ky) + kz;
    float h = q * q + 4.0 * p3;

    h = sqrt(h);
    float2 x = (float2(h, -h) - q) / 2.0;
    float2 uv = sign(x) * pow(abs(x), float2(1.0 / 3.0));
    float t = clamp(uv.x + uv.y - kx, 0.0, 1.0);

    return float2(length(d + (c + b * t) * t), t);
}



float2 rectangle(float t) {
    // Define the points of the rectangle
    float width = 0.9;
    float height = 0.9;
    float2 points[4];
    points[0] = float2(-width, -height);
    points[1] = float2(width, -height);
    points[2] = float2(width, height);
    points[3] = float2(-width, height);
    
    // Determine the current edge
    float segment = fmod(t * 4.0, 4.0);
    int index = int(segment);
    float mixValue = fract(segment);
    
    return mix(points[index], points[(index + 1) % 4], mixValue);
}



float mapRect(float2 pos, float iTime) {
    float t = fract(SPEED * iTime + 0.1);
    float dl = LENGTH / POINTS;
    float2 p1 = rectangle(t * M_2_PI);
    float2 p2 = rectangle((dl + t) * M_2_PI);
    float2 c = (p1 + p2) / 2.0;
    float d = 1e9;
    
    for (float i = 2.0; i < POINTS; i++) {
        p1 = p2;
        p2 = rectangle((i * dl + t) * M_2_PI);
        float2 c_prev = c;
        c = (p1 + p2) / 2.0;
        float2 f = sdBezierRect(pos, c_prev, p1, c);
        d = min(d, f.x + FADING * (f.y + i) / POINTS);
    }
    return d*SCALE;
}



[[stitchable]]
half4 RectangleLoaderEffect(float2 position, half4 currentColor, float2 size,  float iTime) {
    float2 iResolution = size;

    float2 uv = (4*position - 2*iResolution) / min(iResolution.x, iResolution.y);

    float dist = mapRect(uv, iTime);
    
    half4 col = currentColor * pow(RADIUS / dist, GLOW);
    

    return col;

}

