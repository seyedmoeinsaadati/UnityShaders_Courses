Shader "Moein/Skybox/Panoramic_LinearLerp" {
Properties {

    [NoScaleOffset] _Texture1 ("Texture 1", 2D) = "grey" {}
    [NoScaleOffset] _Texture2 ("Texture 2", 2D) = "grey" {}

    [Gamma] _Exposure ("Exposure", Range(0, 8)) = 1.0
    _Tint ("Tint Color", Color) = (.5, .5, .5, .5)
    _Rotation ("Rotation", Range(0, 360)) = 0

    [Space(10)]
    _Lerp ("Threshold", Range(-1, 1)) = 0.01
    _Smoothness ("Smoothness", Range(0.0, 0.5)) = 0.01
    
}

SubShader {
    Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
    Cull Off ZWrite Off

    Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 2.0

        #include "UnityCG.cginc"

        sampler2D _Texture1;
        float4 _Texture1_TexelSize;
        half4 _Texture1_HDR;

        sampler2D _Texture2;
        float4 _Texture2_TexelSize;
        half4 _Texture2_HDR;

        float _Smoothnessness;
        float _Radius;
        float4 _Tiling;

        half4 _Tint;
        half _Exposure;
        float _Rotation, _Lerp;

        bool _MirrorOnBack;
        int _ImageType;
        int _Layout;

        inline float2 ToRadialCoords(float3 coords)
        {
            float3 normalizedCoords = normalize(coords);
            float latitude = acos(normalizedCoords.y);
            float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
            float2 sphereCoords = float2(longitude, latitude) * float2(0.5/UNITY_PI, 1.0/UNITY_PI);
            return float2(0.5,1.0) - sphereCoords;
        }

        float3 RotateAroundYInDegrees (float3 vertex, float degrees)
        {
            float alpha = degrees * UNITY_PI / 180.0;
            float sina, cosa;
            sincos(alpha, sina, cosa);
            float2x2 m = float2x2(cosa, -sina, sina, cosa);
            return float3(mul(m, vertex.xz), vertex.y).xzy;
        }

        struct appdata_t {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        struct v2f {
            float4 vertex : POSITION0;
            float4 position : POSITION1;
            float2 uv : TEXCOORD0;
            float3 texcoord : TEXCOORD12;
            UNITY_VERTEX_OUTPUT_STEREO
        };

        v2f vert (appdata_t v)
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            float3 rotated = RotateAroundYInDegrees(v.vertex, _Rotation);
            o.position = v.vertex;
            o.vertex = UnityObjectToClipPos(rotated);
            o.uv = v.uv;
            o.texcoord = v.vertex.xyz;
       
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float2 tc = ToRadialCoords(i.texcoord);
            
            half4 col1 = tex2D(_Texture1, tc);
            half4 col2 = tex2D(_Texture2, tc);

            float t = smoothstep( i.position.x - _Smoothnessness, i.position.x + _Smoothnessness, _Lerp);
            half3 c = lerp(col1, col2, t);

            c = c * _Tint.rgb * unity_ColorSpaceDouble.rgb;
            c *= _Exposure;
            return half4(c, 1);
        }
        ENDCG
    }
}


Fallback Off

}