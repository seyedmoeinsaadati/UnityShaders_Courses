Shader "ShaderCourse/myPropertiesChallenge4"
{
    Properties
    {
        _myTex("2D Texture", 2D) = "white"{}
        _myEmission("2D Emission", 2D) = "black"{}
        _myNormal("2D Normal", 2D) = ""{}
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _myTex;
        sampler2D _myEmission;
        sampler2D _myNormal;

        struct Input {
            float2 uv_myTex;
            float2 uv_myEmission;
            float2 uv_myNormal;
        };

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = tex2D(_myTex, i.uv_myTex).rgb;
            o.Normal = tex2D(_myNormal, i.uv_myNormal).rgb;
            o.Emission = tex2D(_myEmission, i.uv_myEmission).rgb;
        }

        ENDCG
    }
}