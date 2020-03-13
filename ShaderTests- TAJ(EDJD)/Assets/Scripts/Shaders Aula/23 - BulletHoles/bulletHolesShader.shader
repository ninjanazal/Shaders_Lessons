Shader "Custom/bulletHolesShader"
{
    Properties
    {
        _MainTex("Base Texture", 2D) = "white"{}    // textura basica
        _HitTex("Textura de hit", 2D) = "white"{}   // textura de hit
        [Toggle] _showHit("Display Hit", float) = 0  // toggle de hit
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex; // definiçap interna textura base
        sampler2D _HitTex;  // definiçao da textura de hit
        float _showHit; // definiçao de toogle

        struct Input
        {
            float2 uv_MainTex;  // uvs para a textura basica
            float2 uv_HitTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // define o albedo de acordo com a textura
            o.Albedo = tex2D(_MainTex,IN.uv_MainTex) + (tex2D(_HitTex,IN.uv_MainTex) * _showHit);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
