Shader "TutorialShaders/FirstLookBlend"
{
    Properties{

          _mainTex("Texture", 2D) = "black"{}

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend("Soruce Factor", Float) = 1

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend("Destination Factor", Float) = 1
    }

    SubShader{
        Tags {"Queue"= "Transparent" "RenderType" = "Transparent"}
        Blend [_SrcBlend] [_DstBlend]

        Pass
        {
            SetTexture[_mainTex] { Combine texture}
        }    
    }
    FallBack "Diffuse"
}