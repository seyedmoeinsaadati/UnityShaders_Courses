Shader "ShaderCourse/myPropertiesChallenge2"
{
    Properties
    {
        _myColor("Example Color", COLOR) = (1,1,1,1)
        _myTex("Example 2D Texture", 2D) = "white"{}
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        fixed4 _myColor;
        sampler2D _myTex;

        struct Input {
            float2 uv_myTex;
        };

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo.rb = tex2D(_myTex, i.uv_myTex).rg * _myColor;
            o.Albedo.g = 0.5;
        }

        ENDCG
    }
}