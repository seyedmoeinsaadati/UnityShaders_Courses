Shader "TutorialShaders/FirstLookAlphaToMask"
{
    Properties{

        _mainTex("Texture", 2D) = "black"{}

              
        [Enum(OFF,0,R,8,G,4,B,2,GBA,7,RGB,14,All,15)]
        _Mask("Color Mask", Int) = 1


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