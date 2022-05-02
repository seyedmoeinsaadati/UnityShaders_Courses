Shader "Moein/NormalSample"{
    Properties{}

    SubShader{
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input{
            float2 uv_mainTex;
        };

        void surf (Input IN, inout SurfaceOutput o){
            o.Albedo = o.Normal;
        }
        ENDCG
    }

    Fallback "Diffuse"
}