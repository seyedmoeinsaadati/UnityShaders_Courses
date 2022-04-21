Shader "ShaderCourse/_Passes_Blending/Hologram" 
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RimPower("Rim Power", Range(0.5, 8)) = 1
        _AlphaSlider("Alpha Channel", Range(0, 1)) = 1
        _RimColor("Rim Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        Tags{
            "Queue" ="Transparent"
        }
        Pass{
            ZWrite On
            ColorMask 0
        }
        
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        float _RimPower;
        half _AlphaSlider;
        fixed3 _Color, _RimColor;

        struct Input
        {
            float3 viewDir;
        };

        void surf (Input i, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb * _SinTime.gba;
            float rim = 1- saturate( dot(normalize(i.viewDir), o.Normal));
            o.Emission = _RimColor * pow(rim , _RimPower) * 10;
            o.Alpha = pow(rim, _RimPower) * _AlphaSlider * _SinTime.w;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
