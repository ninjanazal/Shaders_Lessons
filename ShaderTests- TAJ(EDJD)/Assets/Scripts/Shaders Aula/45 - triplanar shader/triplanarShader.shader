Shader "Custom/triplanarShader"
{
    Properties
    {
        [NoScaleOffset]_BottomTexture("Texture fundo", 2D) = "white"{}
        _BottomColor("Bottom Color", Color) = (1,1,1)

        [NoScaleOffset]_TopTexture("Top Texture", 2D) = "white"{}
        _TopColor("Top Color", Color) = (1,1,1)
        _TopVal("Top Value", Range(-1,1)) = 0

        _Scale("scale", Range(0, 20)) = 1

        _Wp("WP", Range(0,2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        // texturas das imagens
        sampler2D _BottomTexture, _TopTexture;
        fixed4 _BottomColor, _TopColor;

        float _Scale, _TopVal;   // valor da escala
        float _Wp;      // valor do suavizador

        struct Input
        {
            float3 worldPos;    // posiçao no mundo
            float3 worldNormal; // normal no mundo
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            // calculo das uvs de acordo com a posiçao no mundo influenciado pela escala
            float3 triplanarUV = IN.worldPos * _Scale;

            float4 x = tex2D(_BottomTexture,triplanarUV.yz);
            float4 y = tex2D(_BottomTexture,triplanarUV.xz);
            float4 z = tex2D(_BottomTexture,triplanarUV.xy);

            float3 peso = pow(abs(IN.worldNormal), _Wp);
            peso /= dot(1, peso);

            float4 bottom_val = (x*peso.x + y*peso.y + z*peso.z) * _BottomColor;

            // influencia da textura de cima            
            float4 xTop = tex2D(_TopTexture , triplanarUV.yz);
            float4 yTop = tex2D(_TopTexture , triplanarUV.xz);
            float4 zTop = tex2D(_TopTexture , triplanarUV.xy);

            float4 top_val = (xTop * peso.x + yTop * peso.y + zTop * peso.z)* _TopColor;

            o.Albedo = lerp(bottom_val , top_val,  (((IN.worldNormal.y - _TopVal) +1)/2)  );
        }
        ENDCG
    }
    FallBack "Diffuse"
}
