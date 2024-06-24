//
//  shders2.metal
//  ShaderEffects
//
//  Created by Grisha Tadevosyan on 18.06.24.
//


#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;



[[stitchable]]
half4 customFragmentShader(float2 position, half4 currentColor, float iTime) {
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
