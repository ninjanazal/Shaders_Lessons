Shader "Aulas/PowDotShader"
{
    Properties
    {
        // cor base1
        _BaseColor1("Base Color",Color ) = (0,0,0,0)
        _BaseColor2("Base Color 2", Color) = (1,1,1,1)
        _BaseColor3("Base Color 3", Color) = (5,5,5,5)

        // valor do expoente
        _PowValue("Pow Value", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags{"Queue" = "Transparent" "RenderType" = "Transparent"}
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // cor base
        fixed4 _BaseColor1;
        fixed4 _BaseColor2;
        fixed4 _BaseColor3;

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
            half dotp = (1 - saturate(dot(IN.viewDir,o.Normal)));
            half powr = pow(dotp , (_PowValue * sin(100 * _Time) + 0.8));

            // if para condiçao de test
            // determina a cor com base no valor determinado de Pow
            o.Albedo = (powr < 0.2  ) ? _BaseColor1 :
            (powr < 0.5) ? _BaseColor2:
            (powr < 0.8) ? _BaseColor3:
            0;

            // atribui á emissao o valor do albedo
            o.Emission = o.Albedo;

            // atribui o alpha de acordo com o valro de powr
            o.Alpha = (powr >= 0.8) ? 0 : 1;


        }
        ENDCG
    }
    FallBack "Diffuse"
}
