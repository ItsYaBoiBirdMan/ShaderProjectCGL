Shader "Hidden/RageModePostProcess"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _HighlightColor ("Highlight Color", Color) = (1,0,0,1)
        _Tolerance ("Tolerance", Range(0,1)) = 0.2
        _GlowIntensity ("Glow Intensity", Range(0, 5)) = 2.0
        _StaticTex ("Static Texture", 2D) = "white" {} 
        _StaticIntensity ("Static Intensity", Range(0, 1)) = 0.5 
        _StaticSpeed ("Static Speed", Range(0, 2)) = 1.0 
        _RandomScale ("Random Scale", Range(0, 5)) = 1.0
        _PulseSpeed ("Pulse Speed", Range(0, 5)) = 1.0
        _PulseIntensity ("Pulse Intensity", Range(0, 0.1)) = 0.01 
        _EdgePulseIntensity ("Edge Pulse Intensity", Range(0, 0.5)) = 0.1 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _StaticTex;
            float4 _HighlightColor;
            float _Tolerance;
            float _GlowIntensity;
            float _StaticIntensity;
            float _StaticSpeed;
            float _RandomScale;
            float _StaticTime;
            float _PulseSpeed;
            float _PulseIntensity;
            float _EdgePulseIntensity;
            
            float PerlinNoise(float2 uv)
            {
                return tex2D(_StaticTex, uv).r;
            }

            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float2 center = float2(0.5, 0.5);
                float2 uv = i.uv;
                
                float zoom = 1.0 + sin(_StaticTime * _PulseSpeed) * _PulseIntensity;
                
                uv = center + (uv - center) / zoom;

                float4 c = tex2D(_MainTex, uv);
                
                float2 offset = float2(PerlinNoise(uv * _RandomScale + float2(_StaticTime * _StaticSpeed, 0.0)),
                                        PerlinNoise(uv * _RandomScale + float2(0.0, _StaticTime * _StaticSpeed))) * _StaticIntensity;

                float2 staticUV = uv + offset;
                float4 staticTex = tex2D(_StaticTex, staticUV);
                
                float gray = dot(c.rgb, float3(0.299, 0.587, 0.114));
                
                float diff = length(c.rgb - _HighlightColor.rgb);

                if (diff <= _Tolerance)
                {
                    c.rgb += _HighlightColor.rgb * _GlowIntensity;
                    c.rgb = clamp(c.rgb, 0, 1);

                    
                    float staticEffect = _StaticIntensity * staticTex.r;
                    c.rgb = lerp(c.rgb, c.rgb + staticEffect, staticEffect);
                }
                else
                {
                    c.rgb = gray.xxx;
                }
                
                float distanceFromCenter = length(uv - center);
                float edgePulse = smoothstep(0.4, 0.6, distanceFromCenter);
                float pulse = sin(_StaticTime * _PulseSpeed) * 0.5 + 0.5;
                c.rgb *= lerp(1.0, 1.0 - edgePulse * pulse * _EdgePulseIntensity, edgePulse);

                return c;
            }
            ENDCG
        }
    }
    FallBack Off
}
