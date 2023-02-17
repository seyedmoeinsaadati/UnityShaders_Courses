﻿Shader "ShaderCourse/BufferQueueShader" {

    Properties {
        _myDiffuse ("Diffuse Texture", Color ) = (1,1,1,1)
        [Enum(On, 0, Off, 1)] _ZWrite("Z Write", Int) = 1
    }

    SubShader {
        Tags{ "Queue"="Geometry+100"}
        ZWrite [_ZWrite]
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input {
            float2 uv_myDiffuse;
        };

        sampler2D _myDiffuse;

        void surf (Input i, inout SurfaceOutput o){
            o.Albedo = tex2D(_myDiffuse, i.uv_myDiffuse).rgb ;

        }
        ENDCG
    }

    Fallback "Diffuse"
}

// struct SurfaceOutput {
    //     fixed3 Albedo;      // diffuse color
    //     fixed3 Normal;      // tangent space normal, if written
    //     fixed3 Emission;
    //     half Specular;      // specular power in 0..1 range
    //     fixed Gloss;        // specular intensity
    //     fixed Alpha;        // alpha for transparencies
// }