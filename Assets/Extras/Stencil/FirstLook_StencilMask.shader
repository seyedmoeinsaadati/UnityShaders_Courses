Shader "TutorialShaders/StencilMask"
{
    Properties{

        [Enum(ON, 1, OFF, 0)]
        _ZWrite("Z Write", Float)  = 1
        _ColorMask("ColorMask", Int)  = 15

        _StencilRef ("Stencil ID", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)]
        _StencilComp ("Stencil Comparison", Float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)]
		_StencilOp ("Stencil Operation", Float) = 0
    }

    SubShader{
        Tags { "Queue"="Geometry-1" }
        ZWrite [_ZWrite]
        ColorMask [_ColorMask]

        Stencil {
            Ref [_StencilRef]
            Comp [_StencilComp]
            Pass [_StencilOp]
        }

        Pass {}   
    }
    FallBack "Diffuse"
}