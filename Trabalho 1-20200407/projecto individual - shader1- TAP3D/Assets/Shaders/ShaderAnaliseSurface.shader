Shader "Analise/ShaderAnaliseSurface"
{
    Properties
    {
        _BaseAlbedo ("Textura de cor", 2D) = "white" {}     // textura de cor

		[Toggle]_NormXPlus("Normal x+", Range(0,1)) = 1		// valor de toggle para x+
		[Toggle]_NormalXMinus("Normal x-", Range(0,1)) = 1	// valor de toggle para x-
		[Toggle]_NormalYPlus("Normal y+", Range(0,1)) = 1	// valor de toggle para y+
		[Toggle]_InvertColor("Inverte cor", Range(0,1)) = 1	// toggle de inversao da cor

		_ClipValue("Valor de clip", Range(0,1)) = 0.5	// valor de clip

    }
    SubShader
    {
        Cull Off
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Unlit noforwardadd
        #pragma target 3.0


        struct Input
        {
            half2 uv_BaseAlbedo;   // uvs na textura de cor
            float3 worldNormal;
        };

        sampler2D _BaseAlbedo;  // textura de cor

		fixed _NormXPlus;				// valor do toggle de normais em x+
		fixed _NormalXMinus;			// valor de toggle de normais em x-
		fixed _NormalYPlus;				// valor de toggle de normais em y+
		fixed _InvertColor;				// valor de toggle para inverter a cor
			
		fixed _ClipValue;				// valor de clip

        // luz, nao recebe sombra
        // para ignorar o valor de luz que o surface incorpora, fazer com que a luz retorne o valor
        // da cor recebida ao input é o suficiente para criar um Unlit
        fixed4 LightingUnlit(SurfaceOutput s, fixed3 lightDir, fixed atten)
        { return fixed4(s.Albedo, s.Alpha);}


        // surface
        void surf (Input IN, inout SurfaceOutput o)
        {
            // guarda valor da cor na imagem de acordo com uvs
            fixed4 c = tex2D (_BaseAlbedo, IN.uv_BaseAlbedo);
            
            // definiçao sobre avaliaçao ternaira para a determinaçao do valor de cor de acordo com toggles
			half4 res = c *(_NormXPlus ? IN.worldNormal.x : 
						    _NormalXMinus ? -IN.worldNormal.x : 
						    _NormalYPlus ? IN.worldNormal.y :
						     1);
			// inverte o valor de cada componente segundo o valor do toggle de inversao
			res = _InvertColor ? 1-res : res; 

			// condiçao que determina se o fragmento é discartado ou nao
			// caso todas as componentes sejam maiores que 0.5 discatar
			if(res.x > _ClipValue && res.y > _ClipValue && res.z > _ClipValue )
			{clip(-1);}

            // cor de saida
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
