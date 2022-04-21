Shader "ShaderCourse/CutoffShader2" {
    Properties{
        _firstColor("Edge Color 1", COLOR) = (1,1,1,1)
        _secondColor("Edge Color 2", COLOR) = (0,0,0,1)
    }
    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 viewDir; 
            float3 worldPos;
        };
        float4 _firstColor, _secondColor;
        void surf (Input i, inout SurfaceOutput o){
            half rim = 1 - saturate(dot(normalize(i.viewDir), o.Normal));
            o.Emission = i.worldPos.y > 1 ? _firstColor * rim : _secondColor * rim;
            //o.Emission.r = frac(i.worldPos.x * 10 * 0.5) > 0.4 ? _firstColor.r: _secondColor.r;
            //o.Emission.g = frac(i.worldPos.y * 10 * 0.5) > 0.4 ? _firstColor.g: _secondColor.g;
            //o.Emission.b = frac(i.worldPos.z * 10 * 0.5) > 0.4 ? _firstColor.z: _secondColor.z;
        }
        ENDCG
    }

    Fallback "Diffuse"
}

// struct SurfaceOutput {
    //     fixed3 Albedo;      // diffuse color
    //     fixed3 Normal;      // tangent space normal, if written
    //     fixed3 Emission;
    //     half Specular;      // specular power in 0..1 range
    //     fixed Gloss;        // specular intensity
    //     fixed Alpha;        // alpha for transparencies
// }