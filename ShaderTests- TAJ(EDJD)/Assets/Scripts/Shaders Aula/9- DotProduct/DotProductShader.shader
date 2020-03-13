Shader "Aulas/DotProductShader"
{
    Properties
    {
        // textura de cor
        _AlbedoTex("Albedo Texture",2D) = "white"{}
        // textura alternativa
        _SecondAlbedoTex("Second Albedo Texture", 2D) = "white"{}
        // Bump map
        [NORMAL]
        _NormalTex("Normal Texture", 2D) = "white"{}
        // Multiplicador de Bump
        _BumpMult("Bump Value", Range(0.1,5)) = 1
        // alcance de textura secundaria
        _SecondTextureVal("TexturaSecundaria", Range(0.7,0.99)) = 0.7
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _AlbedoTex;        // textura de cor
        sampler2D _SecondAlbedoTex;        // textura alternativa
        sampler2D _NormalTex;        // textura de normal
        fixed _BumpMult;        // valor de intencidade
        float _SecondTextureVal;        // valor para a textura secundaria


        struct Input
        {
            // valor de inputShader, 
            // uv para a textura de Albedo
            float2 uv_AlbedoTex;
            // uv para a textura de Normal
            float2 uv_NormalTex;
            // uv para a textura secundaria de Albedo
            float2 uv_SecondAlbedoTex;
            // direcçao de view
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {            
            // atribuir valor da normal
            o.Normal = UnpackNormal(tex2D(_NormalTex ,IN.uv_NormalTex));
            // atribui o valor de bump aos componentes de normais
            // para componetne x e y
            o.Normal.x *= _BumpMult;
            o.Normal.y *= _BumpMult;   

            // calcula o valor do produto escalar para cada pixel
            float dirMultiplicator =  dot(IN.viewDir,o.Normal);

            // caso se o valor for inferior do que o valor definido
            dirMultiplicator = dirMultiplicator < 0.4 ? 0 : dirMultiplicator;

            // atribuir o valor de albedo
            // se o valor for inferior que 0.5f do valor
            if(dirMultiplicator < _SecondTextureVal)
            {
                // atribui o valor do albedo negro
                o.Albedo = tex2D(_AlbedoTex,IN.uv_AlbedoTex) * dirMultiplicator;
            }            
            else
            {
                // atribui a segunda textura
                o.Albedo = tex2D(_SecondAlbedoTex,IN.uv_SecondAlbedoTex);
            }

        }
        ENDCG
    }
    FallBack "Diffuse"
}