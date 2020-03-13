Shader "Aulas/NormalBumpShader"
{
    Properties
    {
        // textura de cor
        _AlbedoTex("Albedo Texture",2D) = "white"{}
        // Bump map
        [NORMAL]
        _NormalTex("Normal Texture", 2D) = "white"{}
        // Multiplicador de Bump
        _BumpMult("Bump Value", Range(0.1,5)) = 1
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // textura de cor
        sampler2D _AlbedoTex;
        // textura de normal
        sampler2D _NormalTex;
        // valor de intencidade
        fixed _BumpMult;

        struct Input
        {
            // valor de inputShader, 
            // uv para a textura de Albedo
            float2 uv_AlbedoTex;
            // uv para a textura de Normal
            float2 uv_NormalTex;
            // direcçao de view
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // atribuir o valor de albedo
            o.Albedo = tex2D(_AlbedoTex,IN.uv_AlbedoTex);
            // atribuir valor da normal
            o.Normal = UnpackNormal(tex2D(_NormalTex ,IN.uv_NormalTex));

            // atribui o valor de bump aos componentes de normais
            // para componetne x e y
            o.Normal.x *= _BumpMult;
            o.Normal.y *= _BumpMult;           
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
