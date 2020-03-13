Shader "Aulas/DotProductAlphaShader"
{
    Properties
    {
        // textura de cor
        _AlbedoTex("Albedo Texture",2D) = "white"{}
        // radio do alpha
        _AlphaRange("AlphaSize", Range(0,1)) = 0.8        
        
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "RenderType" = "Transparent"}
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // textura de input
        sampler2D _AlbedoTex;
        // valor de alpha
        float _AlphaRange;
        

        struct Input
        {
            // valor da uv da textura de input
            float2 uv_AlbedoTex;
            // direcçao da view
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {            
            // atribui a cor ao object
            o.Albedo = tex2D(_AlbedoTex,IN.uv_AlbedoTex);

            // determina a direcçao da camera utilizando as normais
            float dirMultiplicator = dot(IN.viewDir,o.Normal);

            // check se o range ainda se encontra ou nao
            // atribui alpha
            if(dirMultiplicator > _AlphaRange)
            // atribui  0 ao alpha
            o.Alpha = 0;
            else
            o.Alpha = 1;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
