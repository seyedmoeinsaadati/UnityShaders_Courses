Shader "ShaderCourse/_Passes_Blending/BlendTest" 
{
    Properties{
        _mainTex("Texture", 2D) = "black"{}
    }
    SubShader
    {
        Tags{
            "Queue" ="Transparent"
        }

        // Blend [Arg 1] [Arg 2]
        // Blend One One
        // Blend SrcAlpha OneMinusSrcAlpha
        // Blend DstColor SrcAlpha
        
        Pass{
            SetTexture[_mainTex] { Combine texture}
        }    
        
    }
    FallBack "Diffuse"
}

// Syntaxs
// Blend Off: Turn off blending (this is the default)
// Blend SrcFactor DstFactor: Configure and enable blending. The generated color is multiplied by the SrcFactor. The color already on screen is multiplied by DstFactor and the two are added together.
// Blend SrcFactor DstFactor, SrcFactorA DstFactorA: Same as above, but use different factors for blending the alpha channel.
// BlendOp Op: Instead of adding blended colors together, carry out a different operation on them.
// BlendOp OpColor, OpAlpha: Same as above, but use different blend operation for color (RGB) and alpha (A) channels.

// One	The value of one - use this to let either the source or the destination color come through fully.
// Zero	The value zero - use this to remove either the source or the destination values.
// SrcColor	The value of this stage is multiplied by the source color value.
// SrcAlpha	The value of this stage is multiplied by the source alpha value.
// DstColor	The value of this stage is multiplied by frame buffer source color value.
// DstAlpha	The value of this stage is multiplied by frame buffer source alpha value.
// OneMinusSrcColor	The value of this stage is multiplied by (1 - source color).
// OneMinusSrcAlpha	The value of this stage is multiplied by (1 - source alpha).
// OneMinusDstColor	The value of this stage is multiplied by (1 - destination color).
// OneMinusDstAlpha	The value of this stage is multiplied by (1 - destination alpha).

// Operations
// Add	Add source and destination together.
// Sub	Subtract destination from source.
// RevSub	Subtract source from destination.
// Min	Use the smaller of source and destination.
// Max	Use the larger of source and destination.
// LogicalClear	Logical operation: Clear (0) DX11.1 only.
// LogicalSet	Logical operation: Set (1) DX11.1 only.
// LogicalCopy	Logical operation: Copy (s) DX11.1 only.
// LogicalCopyInverted	Logical operation: Copy inverted (!s) DX11.1 only.
// LogicalNoop	Logical operation: Noop (d) DX11.1 only.
// LogicalInvert	Logical operation: Invert (!d) DX11.1 only.
// LogicalAnd	Logical operation: And (s & d) DX11.1 only.
// LogicalNand	Logical operation: Nand !(s & d) DX11.1 only.
// LogicalOr	Logical operation: Or (s | d) DX11.1 only.
// LogicalNor	Logical operation: Nor !(s | d) DX11.1 only.
// LogicalXor	Logical operation: Xor (s ^ d) DX11.1 only.
// LogicalEquiv	Logical operation: Equivalence !(s ^ d) DX11.1 only.
// LogicalAndReverse	Logical operation: Reverse And (s & !d) DX11.1 only.
// LogicalAndInverted	Logical operation: Inverted And (!s & d) DX11.1 only.
// LogicalOrReverse	Logical operation: Reverse Or (s | !d) DX11.1 only.
// LogicalOrInverted	Logical operation: Inverted Or (!s | d) DX11.1 only.
