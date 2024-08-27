Shader "CGL/05 - Bumped Diffuse Lambert"
{
     Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        _MainTex("Texture", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags{"RenderType" = "Transparent"}
        
            
         CGPROGRAM

         #pragma surface surf Lambert

         float4 _Color;
         sampler2D _MainTex;
         sampler2D _NormalMap;
            
         struct Input
         {
             float2 uv_MainTex;
             float2 uv_NormalMap;
         };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Alpha = c.a;
        }

        ENDCG
        
    }
    FallBack "Standard"
}