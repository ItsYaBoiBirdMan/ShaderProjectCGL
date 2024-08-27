Shader "CGL/06 - Bumped Diffuse Standard"
{
     Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
        _Smoothness("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags{"RenderType" = "Transparent"}
        
            
         CGPROGRAM

         #pragma surface surf Standard fullforwardshadows
         #pragma target 3.0

         float4 _Color;
         sampler2D _MainTex;
         sampler2D _NormalMap;
         half _Smoothness;
         half _Metallic;
            
         struct Input
         {
             float2 uv_MainTex;
             float2 uv_NormalMap;
         };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Alpha = c.a;
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
        }

        ENDCG
        
    }
    FallBack "Standard"
}