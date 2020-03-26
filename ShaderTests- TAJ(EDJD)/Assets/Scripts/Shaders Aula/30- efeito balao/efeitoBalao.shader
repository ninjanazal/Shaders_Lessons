Shader "Aulas/efeitoBalao"
{
     Properties
    {
        _Color("cor base", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _InflateAmout("Valor de inflate", Range(-0.5,0.5)) = 0.1
    }
    SubShader
    {

        CGPROGRAM
 
        #pragma surface surf Lambert  vertex:vert

        sampler2D _MainTex;
        fixed4 _Color;

        half _InflateAmout;
        
        struct appdata{

            float4 vertex : POSITION;  // valores da posiçao
            float3 normal : NORMAL;   // valor das normais

            float4 texcoord : TEXCOORD1;
        };
    
        struct Input
        {
            // uvs para a main texture
            float2 uv_MainTex;            
        };
        
        void vert (inout appdata v)
        {
            v.vertex.xy += v.normal * sin(_Time * 10) * _InflateAmout;
            v.vertex.z += v.normal * cos(_Time * 2) * _InflateAmout;

        }

        void surf (Input IN, inout SurfaceOutput o)
        {
     
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _Color.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
