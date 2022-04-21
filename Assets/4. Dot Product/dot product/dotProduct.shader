Shader "ShaderCourse/DotProduct" {

    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float3 viewDir; // ?
        };

        void surf (Input i, inout SurfaceOutput o){
            half dotp = dot(i.viewDir, o.Normal);
            o.Albedo = float3(dotp, 1,1);
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