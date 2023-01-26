Shader "Moein/Simple_Outline"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}

        _OutlineColor("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth("Outline width", Range(-.1, .1)) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}

        Pass
        {
            CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            #pragma vertex vert
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            
            v2f vert (inout appdata_full v)
            {
                o.vertex += v.normal * _OutlineWidth;
            }

            sampler2D _MainTex;

            void surf(Input IN, inout SurfaceOutput o){
                o.Emission = _OutlineColor.rgb;
            }

            
            ENDCG
        }
    }
}
