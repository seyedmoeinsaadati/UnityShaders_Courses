Shader "ShaderCourse/myPropertiesChallenge1"
{
    Properties
    {
        _myColor("Example Color", COLOR) = (1,1,1,1)
        _myRange("Example Range", Range(0, 5)) = 0.5
        _myTex("Example 2D Texture", 2D) = "white"{}
        _myCube("Example CUBE Map", CUBE) = ""{}
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        fixed4 _myColor;
        half _myRange;
        sampler2D _myTex;
        samplerCUBE _myCube;

        struct Input {
            float2 uv_myTex;
            float3 worldRefl;
        };

        void surf (Input i, inout SurfaceOutput o){
            //o.Albedo = tex2D(_myTex, i.uv_myTex).rgb * _myColor * _myRange;
            o.Albedo = (tex2D(_myTex, i.uv_myTex) * _myRange * _myColor).rgb;
            o.Emission = texCUBE(_myCube, i.worldRefl).rgb;
        }

        ENDCG
    }
}