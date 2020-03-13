Shader "Aulas/myToonShader"
{
    Properties
    {
        _baseColor ("Color", Color) = (1,1,1,1) // cor base
        _stepTexture("Step texture", 2D) = "white"{} // textura para steps
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BlinnFCopy
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        fixed4 _baseColor;  // decalraçao da cor base
        sampler2D _stepTexture; // decleraçao da textura


        struct Input
        {
            float2 viewDir; // direcçao da camera
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float dotVal = dot(IN.viewDir,o.Normal);
            // atribui a cor base ao objecto
            o.Albedo =  (dotVal < 0.1) ? 0 : _baseColor;
        }

        // custom light, replica o output do BlinnPhong
        half4 LightingBlinnFCopy(SurfaceOutput s, half3 lightDir, half atten){            
            half diff = dot(s.Normal, lightDir);    // vector difusao da cor
            float stepValue = diff * 0.5 + 0.5; // determina o valor de step
            // determina a cor do step de acordo com a textura
            float3 stepColor = tex2D(_stepTexture,stepValue).rgb;

            float4 c;   // cria var de float 4 para receber a cor final
            // atribui valores aos campos rgb, de acordo com a cor determinada
            c.rgb = s.Albedo * _LightColor0 * stepColor;
            // mantem o valor de alpha
            c.a = s.Alpha;
            // retorna a variavel criada
            return c;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
