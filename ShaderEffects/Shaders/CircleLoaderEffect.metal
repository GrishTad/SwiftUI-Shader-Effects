//
//  CircleLoaderEffect.metal
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 16.11.24.
//


#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Define the Circle function at the global scope
float Circle(float2 uv, float2 center, float radius, float thickness, float seed, float iTime) {
    float dis = distance(center, uv);
    float2 centerToPixel = uv - center;
    float angle = atan2(centerToPixel.y, centerToPixel.x);

    float s1 = sin(angle * 5.0 - iTime + 512.0 + seed) * 0.006;
    float s2 = sin(angle * 2.0 + iTime * 1.8 + 21.0 + seed) * 0.008;
    float noise = s1 + s2;
    return 1.0 - smoothstep(thickness, thickness + 0.013, abs(dis - radius + noise));
}

[[stitchable]]
half4 CircleLoaderEffect(float2 position, half4 currentColor, float2 size, float iTime) {
    float2 fragCoord = position;
    float2 iResolution = size;

    // Normalized pixel coordinates (from 0 to 1)
    float2 uv =fragCoord/min(iResolution.x, iResolution.y);

    
    float aspectRatio = iResolution.y>iResolution.x ? iResolution.y/iResolution.x:iResolution.x/iResolution.y;
    float2 center = iResolution.y>iResolution.x ? float2( 0.5,aspectRatio * 0.5):float2(aspectRatio * 0.5, 0.5);


    // Time-varying pixel color
    float r = Circle(uv, center, 0.4, 0.0065, 42.0, iTime);
    float g = Circle(uv, center, 0.4, 0.0050, 18.0, iTime);
    float b = Circle(uv, center, 0.4, 0.0065, 71.0, iTime);

    // Combine color channels
    half3 col = half3(r, g, b);

    // Compute alpha based on the maximum of the color channels
    float alpha = max(max(r, g), b);

    // Return the final color with computed alpha
    return half4(col, half(alpha)) * currentColor;
  
}



