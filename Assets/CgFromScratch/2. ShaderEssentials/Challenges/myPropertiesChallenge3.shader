Shader "ShaderCourse/myPropertiesChallenge3"
{
    Properties
    {
        _myTex("Example 2D Texture", 2D) = "white"{}
        _myColor("Example Color", Color) = (1,1,1,1)
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _myTex;
        float3 result;
        float4 _myColor;

        struct Input {
            float2 uv_myTex;
        };

        void surf (Input i, inout SurfaceOutput o){
            // o.Albedo.g = tex2D(_myTex, i.uv_myTex).g;
            //float4 green = float4(1,1,1,0);
            o.Albedo = (tex2D(_myTex, i.uv_myTex)*_myColor).rgb;
        }

        ENDCG
    }
}