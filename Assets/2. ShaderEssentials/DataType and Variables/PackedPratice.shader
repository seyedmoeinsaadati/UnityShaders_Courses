Shader "ShaderCourse/PackedPractice"
{
    Properties
    {
        _myColor("Example Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {   
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uvMainTex;
        };

        fixed4 _myColor;

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = _myColor.rgb;
            
        }

        ENDCG
    }
}