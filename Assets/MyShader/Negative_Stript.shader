Shader "Moein/Standard/Negative_Stript"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _myStripWidth ("Strip Width", Range(0, 1)) = 1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float3 viewDir; 
            float3 worldPos;
        };

        fixed4 _Color;
        half _mySlider, _myStripWidth;

        void surf (Input i, inout SurfaceOutput o)
        {
            //half rim = 1 - saturate(dot(normalize(i.viewDir), o.Normal));
            fixed4 secondColor = 1 - _Color;
            o.Albedo = frac(i.worldPos.y * 10 * _myStripWidth) > 0.4 ? i.viewDir : o.Normal.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
