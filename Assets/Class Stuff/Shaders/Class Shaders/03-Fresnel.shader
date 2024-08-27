Shader "CGL/03 - Fresnel"
{
     Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        //_EdgeEnhancement
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "RenderType" = "Transparent"}
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            CGPROGRAM

            #pragma vertex vert
            #pragma  fragment frag

            #include "UnityCG.cginc"

            float4 _Color;

            struct vertexInput
            {
                float4 vertexPos : POSITION;
                float3 normal : NORMAL;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 viewDir : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };
            
            v2f vert(vertexInput input)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(input.vertexPos);
                output.viewDir = normalize(_WorldSpaceCameraPos - mul(unity_ObjectToWorld, input.vertexPos)).xyz;
                output.normal = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject)).xyz;
                return  output;
                
            }

            float4 frag(v2f input) : COLOR
            {
                float newAlpha = min(1.0, _Color.a / (abs(dot(input.viewDir, input.normal))));
                return float4(_Color.rgb, newAlpha);
            }

            ENDCG
        }
    }
    FallBack "Standard"
}