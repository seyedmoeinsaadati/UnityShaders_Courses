Shader "TutorialShaders/FirstLookAlphaToMask"
{
    Properties{

        _mainTex("Texture", 2D) = "black"{}

        [Toggle]
        _AlphaToMask("Alpha To Mask", Float) = 1

    }

    SubShader{
        Tags {}
        AlphaToMask [_AlphaToMask]

        Pass
        {
            SetTexture[_mainTex] { Combine texture}
        }    
    }
    FallBack "Diffuse"
}