Shader "Moein/Skybox/Plasma" {
Properties {

    [NoScaleOffset] _Texture1 ("Texture 1", 2D) = "grey" {}

    [Gamma] _Exposure ("Exposure", Range(0, 8)) = 1.0
    _Tint ("Tint Color", Color) = (.5, .5, .5, .5)
    _Rotation ("Rotation", Range(0, 360)) = 0

    _SpeedU("Speed U", float ) = 0
    _SpeedV("Speed V", float ) = 0

    [Space(20)]
    [Header(Plasma Fields)]
    [Space(10)]
    [Toggle] _PlasmaToggle("Plasma", Float) = 0
    _PlasmaSpeed("Speed", Float) = 10
    _PlasmaWieght("Wieght", Range(0, 1)) = 10
    _PlasmaScale0("General Scale", Float) = 1
	_PlasmaScale1("Vertical Scale", Float) = 2
	_PlasmaScale2("Horizontal Scale", Float) = 2
	_PlasmaScale3("Diagonal Scale", Float) = 2
	_PlasmaScale4("Circular Scale", Float) = 2
}

SubShader {
    Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
    Cull Off ZWrite Off

    Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma target 3.0

        #include "UnityCG.cginc"

        sampler2D _Texture1;
        float4 _Texture1_TexelSize;
        half4 _Texture1_HDR;

        half4 _Tint;
        half _Exposure;
        float _Rotation;

        float _SpeedU, _SpeedV;
        float _PlasmaSpeed, _PlasmaWieght;
		float _PlasmaScale0, _PlasmaScale1, _PlasmaScale2, _PlasmaScale3, _PlasmaScale4;

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

        float4 plasma(float2 pos, float t, float verticalSpeed, float horizontalSpeed, float diagonalSpeed, float circularSpeed){
            //vertical
            float4 c = sin(pos.x * verticalSpeed + t);

            // //horizontal
            c += sin(pos.y * horizontalSpeed + t);

            // // diagonal
            c += sin(diagonalSpeed * (sin(t/2.0) * pos.x + cos(t/3) * pos.y) + t);

            // // circular
            float c1 = pow(pos.x + .5 * sin(t/5), 2);
            float c2 = pow(pos.y + .5 * cos(t/5), 2);
            c += sin(sqrt(circularSpeed * (c1 + c2) + t));

            return c;
        }

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

            float t = _Time.x * _PlasmaSpeed;
            float plasmaValue = abs(plasma(v.vertex.xy, t, _PlasmaScale1, _PlasmaScale2, _PlasmaScale3, _PlasmaScale4));
            o.texcoord.xy += plasmaValue * _PlasmaScale0 * _PlasmaWieght;
            o.texcoord.x += _SpeedU * _Time.x;
            o.texcoord.y += _SpeedV * _Time.x;
       
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float2 tc = ToRadialCoords(i.texcoord);
            
            half3 col1 = tex2D(_Texture1, tc).rgb * _Tint.rgb * unity_ColorSpaceDouble.rgb * _Exposure;
            return half4(col1, 1);
        }
        ENDCG
    }
}


Fallback Off

}