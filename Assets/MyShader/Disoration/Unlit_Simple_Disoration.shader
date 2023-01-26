Shader "Moein/Unlit/Simple_Disoration"
{
    // SinCos   (t/8 , t/4, t/2, t  )
    // time     (t/20, t  , t*2, t*3)
    Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_LensDistortionTightness ("Lens Distortion Tightness", Range(0, 10)) = 1
		_LensDistortionStrength ("Lens Distortion Strength", Range(0, 1)) = 1
	}
	SubShader
    {
        // Draw after all opaque geometry
        Tags { "Queue" = "Transparent" }

        // Grab the screen behind the object
        GrabPass{}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uvGrab : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _MainTex;
			float4 _MainTex_ST;
            float _LensDistortionTightness;
            float _LensDistortionStrength;

            v2f vert(appdata v) {
				 
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uvGrab = ComputeGrabScreenPos(o.vertex);
                
				o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                
                // o.uvGrab.x = o.uvGrab.x - 1;
                // o.uvGrab.y = o.uvGrab.y - 1;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {

                float distortionMagnitude = length(i.uvGrab.xy);
                distortionMagnitude = abs(i.uvGrab[0]*i.uvGrab[1]);
                // return distortionMagnitude;
                // const float smoothDistortionMagnitude = pow(distortionMagnitude, _LensDistortionTightness);//use exponential function
                // return smoothDistortionMagnitude;
                // const float smoothDistortionMagnitude =1-sqrt(1-pow(distortionMagnitude,_LensDistortionTightness));//use circular function
                const float smoothDistortionMagnitude =pow(sin(UNITY_HALF_PI*distortionMagnitude),_LensDistortionTightness);// use sinusoidal function
                // return smoothDistortionMagnitude;// previewing smooth distortion map

                float4 uvDistorted = i.uvGrab * smoothDistortionMagnitude * _LensDistortionStrength;

                fixed4 col = 0;
                if (uvDistorted.x < 0 || uvDistorted.x > 1 || uvDistorted.y < 0 || uvDistorted.y > 1) {
                    return col;
                } else {
                    col = tex2Dproj(_GrabTexture, uvDistorted);
                    return col;
                }
                
                // fixed4 col = tex2Dproj(_GrabTexture, i.uvGrab);
				// fixed4 tint = tex2D(_MainTex, i.uv);
				// col *= tint;
                // return col;
            }
            ENDCG
        }

    }
}
