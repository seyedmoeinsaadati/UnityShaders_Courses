Shader "ShaderCourse/DotProduct"
{
    Properties{
        _Color ("Color" , Color) = (1,1,1,1)
        _Slider ("Power: ", Range (0, 10)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float3 viewDir;
        };

        half3 _Color;
        half _Slider;

        void surf (Input IN, inout SurfaceOutput o)
        {
            // half dotValue = dot(IN.viewDir, o.Normal) ;
            half dotValue =pow(1-dot(IN.viewDir, o.Normal), _Slider);
            o.Albedo = float3(dotValue,dotValue,dotValue) * _Color ;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
