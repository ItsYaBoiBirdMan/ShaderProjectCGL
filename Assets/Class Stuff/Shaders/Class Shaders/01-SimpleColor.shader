Shader "CGL/01 - Simple Color"
{
    Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma  fragment frag
            
            float4 _Color;
            
            float4 vert(float4 vertexPos : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }

            float4 frag(void) : COLOR
            {
                return _Color;
            }

            ENDCG
        }
    }
    FallBack "Standard"
}