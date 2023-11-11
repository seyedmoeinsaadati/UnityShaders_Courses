Shader "Moein/Custom Shadow"
{
    Properties
    {
		_LightDirection("Light Direction", Vector) = (0,0,0,0)
		_ShadowBias("Shadow Bias", Vector) = (0,0,0,0)

        [Enum(UnityEngine.Rendering.CullMode)]
        _ShadowCull("Shadow Caster Cull", Int) = 2

		[Enum(OFF,0,Less,4,Greater,7)] _ZTest("Depth Test", Int) = 4
		[Enum(OFF,0,ON,1)] _ZWrite("Depth Write", Int) = 1
    }
    SubShader
    {
		//  CGPROGRAM
        // #pragma surface surf Lambert

        // // Input data from the model's mesh (vertices, normals, uvs, ...)
        // struct Input {
        //     float2 uvMainTex;
        // };

        // void surf (Input i, inout SurfaceOutput o){
        //     o.Albedo = float3 (1,1,1);
        // }
        // ENDCG

        Pass
		{
			Name "ShadowCaster"
			Tags {"LightMode" = "ShadowCaster"}

         	Cull [_ShadowCull]
			ZTest [_ZTest]
			ZWrite [_ZWrite]

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing

			#include "UnityCG.cginc"

			float4 _LightDirection;
			float4 _ShadowBias;

			struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };


			struct v2f
			{
				// V2F_SHADOW_CASTER;
				float3 vec : TEXCOORD0;
				// UNITY_POSITION(pos);
				float4 pos : POSITION;
			};
			// Computes world space custom light direction, from world space position
			float3 C_UnityWorldSpaceLightDir( in float3 worldPos )
			{
				#ifndef USING_LIGHT_MULTI_COMPILE
					return _LightDirection.xyz - worldPos * _LightDirection.w;
				#else
					#ifndef USING_DIRECTIONAL_LIGHT
					return _LightDirection.xyz - worldPos;
					#else
					return _LightDirection.xyz;
					#endif
				#endif
			}
			
			float4 C_UnityClipSpaceShadowCasterPos(float4 vertex, float3 normal)
			{
				float4 wPos = mul(unity_ObjectToWorld, vertex);

				if (_ShadowBias.z != 0.0)
				{
					float3 wNormal = UnityObjectToWorldNormal(normal);
					float3 wLight = normalize(C_UnityWorldSpaceLightDir(wPos.xyz));

					// apply normal offset bias (inset position along the normal)
					// bias needs to be scaled by sine between normal and light direction
					// (http://the-witness.net/news/2013/09/shadow-mapping-summary-part-1/)
					//
					// unity_LightShadowBias.z contains user-specified normal offset amount
					// scaled by world space texel size.

					float shadowCos = dot(wNormal, wLight);
					float shadowSine = sqrt(1-shadowCos*shadowCos);
					float normalBias = _ShadowBias.z * shadowSine;

					wPos.xyz -= wNormal * normalBias;
				}

				return mul(UNITY_MATRIX_VP, wPos);
			}

			float4 C_UnityApplyLinearShadowBias(float4 clipPos)
			{
				// For point lights that support depth cube map, the bias is applied in the fragment shader sampling the shadow map.
				// This is because the legacy behaviour for point light shadow map cannot be implemented by offseting the vertex position
				// in the vertex shader generating the shadow map.
				#if !(defined(SHADOWS_CUBE) && defined(SHADOWS_CUBE_IN_DEPTH_TEX))
					#if defined(UNITY_REVERSED_Z)
						// We use max/min instead of clamp to ensure proper handling of the rare case
						// where both numerator and denominator are zero and the fraction becomes NaN.
						clipPos.z += max(-1, min(_ShadowBias.x / clipPos.w, 0));
					#else
						clipPos.z += saturate(_ShadowBias.x/clipPos.w);
					#endif
				#endif

				#if defined(UNITY_REVERSED_Z)
					float clamped = min(clipPos.z, clipPos.w*UNITY_NEAR_CLIP_VALUE);
				#else
					float clamped = max(clipPos.z, clipPos.w*UNITY_NEAR_CLIP_VALUE);
				#endif
					clipPos.z = lerp(clipPos.z, clamped, _ShadowBias.y);
					return clipPos;
			}

			v2f vert(appdata v)
			{
				v2f o;
				// UNITY_SETUP_INSTANCE_ID(v);
				rotate(v.normal.xy, v.normal.xy, _LightDirection.x, v.normal.xy);
				// TRANSFER_SHADOW_CASTER_NORMALOFFSET(o) ->
				// TRANSFER_SHADOW_CASTER_NOPOS(o,o.pos) ->
				o.vec = mul(unity_ObjectToWorld, v.vertex).xyz - _LightDirection.xyz;
				// o.pos = UnityObjectToClipPos(v.vertex);

				o.pos = C_UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
        		o.pos = C_UnityApplyLinearShadowBias(o.pos);

				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				// return float4(1,0,0,0);
				SHADOW_CASTER_FRAGMENT(i)
				// return UnityEncodeCubeShadowDepth ((length(i.vec) + _ShadowBias.x) * _LightDirection.w);
			}

			ENDCG
		}
    }
}
