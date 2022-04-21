Shader "ShaderCourse/UnderstandingWorldRefl" {

    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_myDiffuse;
            float3 worldRefl;
            float3 worldPos;
        };

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = i.worldRefl ;
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