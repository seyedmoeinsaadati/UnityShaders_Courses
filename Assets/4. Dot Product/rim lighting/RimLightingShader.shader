Shader "ShaderCourse/RimLightingShader" {
    Properties{
        _RimColor("Rim Color", COLOR) = (1,1,1,1)
        _RimPower("Rim Power", Range(0.5, 8)) = 1
    }
    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 viewDir; 
        };
        float4 _RimColor;
        float _RimPower;
        void surf (Input i, inout SurfaceOutput o){
            half rim = 1 - saturate(dot(normalize(i.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow(rim, _RimPower);
            //  o.Albedo = 1 - _RimColor.rgb;
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