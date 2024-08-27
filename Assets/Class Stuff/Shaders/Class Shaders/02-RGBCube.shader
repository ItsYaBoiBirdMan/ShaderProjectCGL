Shader "CGL/02 - RGB Cube"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma  fragment frag
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color: TEXCOORD0;
            };
            
            v2f vert(float4 vertexPos : POSITION)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(vertexPos);
                output.color = vertexPos + float4(0.5, 0.5, 0.5, 1);
                return  output;
                
            }

            float4 frag(v2f input) : COLOR
            {
                return input.color;
            }

            ENDCG
        }
    }
    FallBack "Standard"
}