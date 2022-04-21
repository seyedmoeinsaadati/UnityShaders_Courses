Shader "ShaderCourse/UnderstandingNormal" {

    SubShader {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_myDiffuse;
        };

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = o.Normal;
        }
        ENDCG
    }

    Fallback "Diffuse"
}