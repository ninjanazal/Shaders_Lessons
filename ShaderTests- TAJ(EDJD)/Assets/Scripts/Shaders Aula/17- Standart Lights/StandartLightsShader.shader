Shader "Aulas/StandartLightsShader"
{
    Properties
    {
        _colorMulti("Multiplicador de Cor", Color) = (1,1,1,1)  // cor 
        _baseColor("Base Color", 2D) = "white" {} // cor base
        _baseTexture("Texutra 1" , 2D) = "white"{}  // textura base 1
        _smoothMetalic("Valor de Metalica", Range(0,1)) = 1 // slider para o metalico
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        fixed3 _colorMulti; // multiplicador de cor
        sampler2D _baseColor;  // declaraçao da cor base
        sampler2D _baseTexture; // declaraçao textura 1
        half _smoothMetalic;    // declaraçao do valor

        struct Input
        {
            float2 uv_baseColor;    // uvs da textura de cor
            float2 uv_baseTexture;  // uvs da textura base
        };
        

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // atribui á cor
            o.Albedo = tex2D(_baseColor,IN.uv_baseColor) * _colorMulti * 5;
            // atribui o valor de smooth de acordo com a textura
            o.Smoothness =1- tex2D(_baseTexture, IN.uv_baseTexture).g;
            o.Metallic = _smoothMetalic;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
