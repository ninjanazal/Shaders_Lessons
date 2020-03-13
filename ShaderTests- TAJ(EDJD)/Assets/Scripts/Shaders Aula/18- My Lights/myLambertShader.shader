Shader "Aulas/myLambertShader"
{
    Properties
    {
        _BaseColor ("Color", Color) = (1,1,1,1) // Cor de objecto
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf LambertCopia
        // custom light, replica o output do Lambert
        half4 LightingLambertCopia(SurfaceOutput s, half3 lightDir, half atten){
            // dot product da direcçao da normal com a direcçao da luz
            half NdotL = saturate(dot(s.Normal, lightDir));
            half4 c;

            // cor de albedo é determinada para direcçao total das luzes multiplicado pela 
            // atenuaçao 
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            // atribui o alpha
            c.a = s.Alpha;

            return c;
        }

        // custom light, replica o output do BlinnPhong
        half4 LightingBlinnFCopy(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten){
            half3 h = normalize(lightDir + viewDir);
            half diff = max(0,dot(s.Normal, lightDir));
            float nh = max(0, dot(s.Normal, h));
            float spec = pow(nh,48.0);

            half4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
            c.a = s.Alpha;
            return c;
        }

        fixed3 _BaseColor;  // declaraçao da cor

        struct Input{
            float2 viewDir; // input da direcçao da camera
        };  

        void surf (Input IN, inout SurfaceOutput o){
            o.Albedo = _BaseColor;  // atribui a cor ao objecto
        }
        ENDCG
    }
    FallBack "Diffuse"
}
