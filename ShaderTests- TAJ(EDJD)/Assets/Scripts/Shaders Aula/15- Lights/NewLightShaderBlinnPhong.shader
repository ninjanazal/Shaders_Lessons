Shader "Aulas/NewLightShader"
{
    // primeiro shader(em aula)
    Properties
    {
        // inputs
        // nome no inspector, tipo de var, valor inicial
        _myColor("Base Color", Color) = (1,1,1,1)   // cor base
        _SpecColor("Colour", Color) = (1,1,1,1) // cor especular

        _spec_val("Specular",Range(0,1)) = 0.5  // valor especular
        _gloss_val("Gloss",Range(0,1)) = 0.5     // valor de gloss
    }
    SubShader
    {
        CGPROGRAM
        // defenição de informaçoes relacionadas com o comportamento s
        #pragma surface surf BlinnPhong

        // vector definido na entrada do shader
        fixed3 _myColor; // cor base
        half _spec_val;     //  valor especular
        fixed _gloss_val;    // valor gloss


        // Estrutura de input
        struct Input {
            float4 screenPos; // posiçao no ecra
            float3 viewDir; //direcçao da camera
        };

        // surface shader, com input nas entradas do parametro e output de surfaceOut
        void surf(Input IN, inout SurfaceOutput  o) {
            // aplica cor determinada e aplica ao albedo do obj
            o.Albedo = _myColor;

            // atribui valor de especular e gloss aos valores de saidas
            o.Specular = _spec_val;
            o.Gloss = _gloss_val;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
