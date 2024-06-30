//
//  shders2.metal
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 18.06.24.
//


#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


/////////////////////////////////////////// ColorMixEffect /////////////////////////////////////
[[stitchable]]
half4 ColorMixEffect(float2 position, half4 currentColor, float iTime) {
    // Position needs to be normalized as per your previous approach
    float2 iResolution = float2(400.0, 400.0);

    float2 uv = 1.5 * (position - 0.5) / fmax(iResolution.x, iResolution.y);
    float2 mse = 0.3 / iResolution - 0.3;
    float speed = 100.0;
    float t = iTime / 100.0 * speed;

    for (float i = 1.0; i < 10.0; i += 1.0) {
        float2 newUv = uv;
        newUv.x += mse.x / i * sin(i * i * uv.y + 0.3 * t) + 1.0;
        newUv.y += mse.y / i * sin(i * i * uv.x + 0.3 * (t + 10.0)) - 1.4;
        uv = newUv;
    }

    float3 col = float3(
        0.5 + sin(3.0 * uv.y) * 0.5,
        0.5 + sin(3.0 * uv.x) * 0.5,
        0.5 + sin(3.0 * (uv.x + uv.y)) * 0.5
    );
    half4 newColor = half4(half(col.x), half(col.y), half(col.z), half(1.0));
    return  newColor * currentColor.a ;

}

////////////////////////////////////////// Infinite Loader ///////////////////////////////////////////
#define M_2_PI 6.28318530

#define SCALE 1.3
#define SPEED 0.5
#define POINTS 15.0
#define LENGTH 0.6
#define RADIUS 0.08
#define FADING 0.28
#define GLOW 1.5

float2 sdBezier(float2 pos, float2 A, float2 B, float2 C)
{
    float2 a = B - A;
    float2 b = A - 2.0 * B + C;
    float2 c = a * 2.0;
    float2 d = A - pos;

    float kk = 1.0 / dot(b, b);
    float kx = kk * dot(a, b);
    float ky = kk * (2.0 * dot(a, a) + dot(d, b)) / 3.0;
    float kz = kk * dot(d, a);

    float2 res;

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

float2 leminiscate(float t) {
    float x = SCALE * cos(t) / (1.0 + sin(t) * sin(t));
    float y = SCALE * sin(t) * cos(t) / (1.0 + sin(t) * sin(t));
    return float2(x, y);
}

float map(float2 pos, float iTime) {
    float t = fract(SPEED * iTime + 0.1);
    float dl = LENGTH / POINTS;
    float2 p1 = leminiscate(t * M_2_PI);
    float2 p2 = leminiscate((dl + t) * M_2_PI);
    float2 c = (p1 + p2) / 2.0;
    float d = 1e9;
    
    for (float i = 2.0; i < POINTS; i++) {
        p1 = p2;
        p2 = leminiscate((i * dl + t) * M_2_PI);
        float2 c_prev = c;
        c = (p1 + p2) / 2.0;
        float2 f = sdBezier(pos, c_prev, p1, c);
        d = min(d, f.x + FADING * (f.y + i) / POINTS);
    }
    return d;
}

[[stitchable]]
half4 InfiniteLoaderEffect(float2 position, half4 currentColor, float2 size,  float iTime) {
    float2 iResolution = size;

    float2 uv = (4*position - 2*iResolution) / min(iResolution.x, iResolution.y);

    float dist = map(uv, iTime);
    
    half4 col = currentColor * pow(RADIUS / dist, GLOW);
    

    return col;

}

