Shader "Aulas/WorldPosShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // cor base
        fixed4 _Color;

        struct Input
        {
            // direcçao da camera
            float2 viewDir;
            // posiçao no mundo do objecto
            float3 worldPos;
        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {   
            // albedo determinado pela pesiçao do mundo
            o.Albedo = frac(IN.worldPos.y * 2)/ 2 > 0.4 ? _Color : 0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
