Shader "Custom/PowShader"
{
    Properties
    {
        // cor base
        _MainColor("Base Color",Color ) = (0,0,0,0)
        // valor do expoente
        _PowValue("Pow Value", Range(0,5)) = 2
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // cor base
        fixed4 _MainColor;
        // valor do expoent
        fixed _PowValue;

        struct Input
        {
            // direcçao de view da camera
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {   
            // valor do produto escalar entre a direcao de view da camera
            // com a direcçao da normal
            half dotp =1- dot(IN.viewDir,o.Normal);

            // atribui a cor ao objecto            
            o.Albedo = _MainColor;
            o.Emission = -1* pow(dotp,_PowValue);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
