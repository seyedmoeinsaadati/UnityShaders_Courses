Shader "TutorialShaders/FirstLookColorMask"
{
    Properties{
        _mainTex("Texture", 2D) = "black"{}
        _Mask("Color Mask (RGBA)", Int) = 15
    }

    SubShader{
        Tags {}
        ColorMask [_Mask]

        Pass
        {
            SetTexture[_mainTex] { Combine texture}
        }    
    }
    FallBack "Diffuse"
}