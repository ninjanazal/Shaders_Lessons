Shader "Custom/BlendtoTransShader"
{
    Properties
    {
        _base_color("Cor Base", Color) =(0,0,0,0)   // cor base    
        _range("range", Range(0,1)) = 0.8   // range para control do valor de dot*
        [Toggle] _activateSin("Activar sinTime", float) = 0
    }
    SubShader
    {
        Tags {"Queue" = "Transparent"}

        Blend SrcAlpha OneMinusSrcAlpha
        /* pass{// pass do render
            ZWrite Off            
        }  */
        CGPROGRAM

        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha:fade
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // internel redifined var
        fixed4 _base_color; // cor base
        float _range;   // alcance
        float _activateSin; // toggle desin

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
            //o.Albedo = o.Emission;
            // atribui o alpha de acordo com o valor do dot
            // caso tenha o toggle acivo
            if(_activateSin)
            o.Alpha = dotVector * sin(40 * _Time);
            else
            // caso nao tenha o toggle activo
            o.Alpha = dotVector;
            o.Albedo = dotVector* _base_color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}