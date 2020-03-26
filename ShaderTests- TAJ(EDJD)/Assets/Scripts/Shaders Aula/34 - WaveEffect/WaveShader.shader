Shader "Aulas/WaveShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

        _Amplitude("Amplitude", Range(1,10)) = 1  
        _Frequencia("Freq", Range(1,10)) = 1 
        _Speed("Velocidade", Range(1,50)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert fullshadowsforward vertex:vert

        
        struct appdata{
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            // needed para passar ao surf
            float4 texcoord : TEXCOORD0;
        };

        struct Input
        {
            float2 uv_MainTex;
            float3 vertColor;   // cor do vertex
        };

        // vars
        sampler2D _MainTex;    
        fixed _Amplitude, _Frequencia, _Speed;
        fixed4 _Color;

        void vert (inout appdata v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);  // inicializaçao da estrutura    
            float funcTime = _Time * _Speed;    // altare a projecçao do tempo com base na var de speed
            float waveHeight = sin(funcTime + v.vertex.x *_Frequencia) * _Amplitude;
            v.vertex.y += waveHeight;

            v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y,v.normal.z));
            o.vertColor = waveHeight + 2.5;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 col = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            //o.Albedo = col * IN.vertColor;
            o.Albedo = col -  smoothstep(col, IN.vertColor, 0.5);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
