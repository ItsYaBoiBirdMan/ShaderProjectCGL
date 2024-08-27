Shader "CGL/07 - Hue Shift "
{
     Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Smoothness("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _HueShift("Hue Min (X), Hue Max (Y), Shift (Z), Saturation (W)", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags{"RenderType" = "Transparent"}
        
            
         CGPROGRAM

         #pragma surface surf Standard fullforwardshadows
         #pragma target 3.0

         float3 RGBToHSV(float3 c)
        {
            float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
            float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
            float d = q.x - min(q.w, q.y);
            float e = 1.0e-10;
            return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
        }
 
        float3 HSVToRGB(float3 c)
        {
            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
            float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
            return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
        }

         float4 _Color;
         sampler2D _MainTex;
         sampler2D _NormalMap;
         half _Smoothness;
         half _Metallic;
         float4 _HueShift;
            
         struct Input
         {
             float2 uv_MainTex;
             float2 uv_NormalMap;
         };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float4 clr = tex2D(_MainTex, IN.uv_MainTex);
            float3 c = RGBToHSV(clr.rgb);
            if(c.x >= _HueShift.x && c.x <= _HueShift.y)
            {
                c.x += _HueShift.z;
                c.y = saturate(c.y +_HueShift.w);
            }
            
            o.Albedo = HSVToRGB(c) * _Color;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Alpha = clr.a;
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }

        ENDCG
        
    }
    FallBack "Standard"
}