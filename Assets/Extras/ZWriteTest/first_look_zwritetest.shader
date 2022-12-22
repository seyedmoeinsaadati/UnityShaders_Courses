Shader "TutorialShaders/FirstLookZWriteTest"
{
    Properties{
        _mainTex("Texture", 2D) = "black"{}
        [Enum(ON, 1, OFF, 0)]
        _ZWrite("Z Write", Float)  = 1
        [KeywordEnum(Less, Less, Greater,Greater,LEqual,LEqual,GEqual,GEqual,Equal,Equal,NotEqual,NotEqual,Always,Always)]
        _ZTest("Z Test", Int)  = 1
    }

    SubShader{
        Tags {}
        ZWrite [_ZWrite]
        ZTest [_ZTest]
        
        Pass
        {
            SetTexture[_mainTex] { Combine texture}
        }    
    }
    FallBack "Diffuse"
}