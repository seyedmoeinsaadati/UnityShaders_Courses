Shader "ShaderCourse/CutoffShader" {
    Properties{
        _firstColor("Edge Color 1", COLOR) = (1,1,1,1)
        _secondColor("Edge Color 2", COLOR) = (1,1,1,1)
    }
    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 viewDir; 
        };
        float4 _firstColor, _secondColor;
        void surf (Input i, inout SurfaceOutput o){
            half rim = 1 - saturate(dot(normalize(i.viewDir), o.Normal));
            o.Emission = rim > 0.5 ? _firstColor : rim > 0.3 ? _secondColor : 0;
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