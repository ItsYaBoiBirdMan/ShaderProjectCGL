Shader "CGL/08 - Rain on Glass"
{
     Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _RefractionMap1("Refraction Map 1", 2D) = "bump" {}
        _RefractionStrength1("Refraction Strenght 1", float) = 8
        _RefractionMap2("Refraction Map 2", 2D) = "bump" {}
        _RefractionStrength2("Refraction Strength 2", float) = 8
        _NormalMap("Normal Map", 2D) = "bump" {}
        _MainTex("Albedo", 2D) = "white" {}
        _Speed("Flow Speed 1 (XY)", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "RenderType" = "Transparent"}
        
        GrabPass
        {
            "_ScreenGrab"
        }
        
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma  fragment frag

            #include "UnityCG.cginc"

            float4 _Color;

            struct vertexInput
            {
                float4 vertexPos : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uvmain : TEXCOORD0;
                float4 uvgrab : TEXCOORD1;
                float2 uvbump : TEXCOORD2;
                float2 uvbump2 : TEXCOORD3;
                float2 uvbump3 : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _ScreenGrab;
            float4 _ScreenGrab_TexelSize;

            sampler2D _RefractionMap1;
            float4 _RefractionMap1_ST;
            float _RefractionStrength1;

            sampler2D _RefractionMap2;
            float4 _RefractionMap2_ST;
            float _RefractionStrength2;

            sampler2D _NormalMap;
            float4 __NormalMap_ST;

            float4 _Speed;
            
            v2f vert(vertexInput input)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(input.vertexPos);
                output.uvmain = TRANSFORM_TEX(input.uv, _MainTex);
                output.uvgrab = ComputeGrabScreenPos(output.pos);
                output.uvbump = TRANSFORM_TEX(input.uv, _RefractionMap1);
                output.uvbump2 = TRANSFORM_TEX(input.uv, _RefractionMap2);
                //output.uvbump3 = TRANSFORM_TEX(input.uv, _NormalMap);
                return  output;
                
            }

            float4 frag(v2f input) : COLOR
            {
                half2 bump = UnpackNormal(tex2D(_RefractionMap1, input.uvbump + _Speed.xy * _Time.x)).rg;
                float2 offset = bump * _ScreenGrab_TexelSize.xy * (_RefractionStrength1 * _RefractionStrength1);
                
                bump = UnpackNormal(tex2D(_RefractionMap2, input.uvbump2 + _Speed.zw * _Time.x)).rg;
                offset += bump * _ScreenGrab_TexelSize.xy * (_RefractionStrength2 * _RefractionStrength2);

                input.uvgrab.xy = offset * input.uvgrab.z + input.uvgrab.xy;
                half4 col = tex2Dproj(_ScreenGrab, input.uvgrab);
                col *= tex2D(_MainTex, input.uvmain);
                return col; 
            }

            ENDCG
        }
    }
    FallBack "Standard"
}