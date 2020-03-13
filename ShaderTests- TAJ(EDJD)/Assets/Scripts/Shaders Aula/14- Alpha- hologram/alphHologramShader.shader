Shader "Aulas/alphHologramShader"
{
    Properties
    {
        _base_color("Cor Base", Color) =(0,0,0,0)   // cor base    
        _range("range", Range(0,1)) = 0.8   // range para control do valor de dot*
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Opaque" }
        CGPROGRAM

        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha:fade
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // internel redifined var
        fixed4 _base_color; // cor base
        float _range;

        // input
        struct Input
        {
            // direcçao de view da camera
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // determinar o valor de direcçao dot
            float dotVector = saturate(dot(IN.viewDir, o.Normal));
            // atribui emissao com base no produto            
            o.Emission = _base_color *  pow(dotVector, _range) * 5;
            // atribui o alpha de acordo com o valor do dot
            o.Alpha = dotVector * sin(40 * _Time);
            o.Albedo = dotVector* _base_color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
