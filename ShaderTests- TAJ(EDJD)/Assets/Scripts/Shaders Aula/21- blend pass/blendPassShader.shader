Shader "Aulas/blendPassShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}  // textura base

    }
    SubShader
    {
        // tag de transparencia
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"} 

        Blend SrcAlpha OneMinusSrcAlpha  // toma em conta todos as cores de entrada

        Pass{
            SetTexture [_MainTex] {combine texture}
        }
        
    }
    FallBack "Diffuse"
}