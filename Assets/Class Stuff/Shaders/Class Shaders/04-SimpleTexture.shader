Shader "CGL/04 - Simple Texture"
{
     Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags{"RenderType" = "Transparent"}
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM

            #pragma vertex vert
            #pragma  fragment frag

            #include "UnityCG.cginc"

            float4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct vertexInput
            {
                float4 vertexPos : POSITION;
                float3 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            v2f vert(vertexInput input)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(input.vertexPos);
                output.uv = TRANSFORM_TEX(input.uv, _MainTex);
                return  output;
                
            }

            float4 frag(v2f input) : COLOR
            {
                return tex2D(_MainTex, input.uv) * _Color;
            }

            ENDCG
        }
    }
    FallBack "Standard"
}