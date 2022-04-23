Shader "ShaderCourse/myPropertiesChallenge4"
{
    Properties {
        _albedoTex("Albedo Texture", 2D) = "white" {}
        // _emissionTex("Emission Texture", 2D) = "white" {}
        _emissionTex("Emission Texture", 2D) = "black" {}
    }
    SubShader
    {   
        CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _albedoTex;
            sampler2D _emissionTex;

            struct Input {
                float2 uv_albedoTex;
                float2 uv_emissionTex;
            };

            void surf(Input i, inout SurfaceOutput o){
                o.Albedo = (tex2D(_albedoTex, i.uv_albedoTex)).rgb;
                o.Emission = (tex2D(_emissionTex, i.uv_emissionTex)).rgb;
            }

        ENDCG
    }

    // Fallback "Diffuse"
}