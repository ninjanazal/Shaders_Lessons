Shader "Analise/ShaderAnalise"
{
   // shader numero 1 para Analise

    	Properties
	{
		_BaseAlbedo ("Textura de Cor", 2D) = "white" {}	// textura de cor

		[Toggle]_NormXPlus("Normal x+", Range(0,1)) = 1		// valor de toggle para x+
		[Toggle]_NormalXMinus("Normal x-", Range(0,1)) = 1	// valor de toggle para x-
		[Toggle]_NormalYPlus("Normal y+", Range(0,1)) = 1	// valor de toggle para y+
		[Toggle]_InvertColor("Inverte cor", Range(0,1)) = 1	// toggle de inversao da cor
		
		_ClipValue("Valor de clip", Range(0,1)) = 0.5	// valor de clip
	}

	SubShader
	{	
	
		Cull Off	// desativa o culling de faces, mostra todas as faces voltadas ou nao
		Tags { "RenderType"="Opaque" }	// tipo de render

	
		Pass
		{
			CGPROGRAM
			#pragma vertex vert	// definiçao da funçao de vertex
			#pragma fragment frag	// definiçao da funçao do fragmet
			
			#include "UnityCG.cginc"

			// estrutura de entrada
			struct appdata
			{
				half4 pos : POSITION;	// posiçoes de vertice do obj
				half3 normal : NORMAL;	// valor da normal no obj
				half2 uv : TEXCOORD0;	// coordenadas de uvs
			};

			// estrutura de transiçao, vertex 2 fragmet
			struct v2f
			{
				float4 pos : SV_POSITION;	// posiçoes projectadas em clip
				half3 normal : NORMAL;		// valor de normal no obj
				half2 uv : TEXCOORD0;		// coordenadas de uvs
			};

			sampler2D _BaseAlbedo;			// textura de cor 
			half4 _BaseAlbedo_ST;			// para tilling

			fixed _NormXPlus;				// valor do toggle de normais em x+
			fixed _NormalXMinus;			// valor de toggle de normais em x-
			fixed _NormalYPlus;				// valor de toggle de normais em y+
			fixed _InvertColor;				// valor de toggle para inverter a cor
			
			fixed _ClipValue;				// valor de clip
			// vertex shader
			v2f vert (appdata i)
			{
				v2f o;		// definiçao da estrutura de saida	
				o.pos = UnityObjectToClipPos(i.pos);	// transformaçao da posiçao em valores de clip
				o.uv = TRANSFORM_TEX(i.uv, _BaseAlbedo) ;	// passa as uvs de entrada para a estrutura
				o.normal = i.normal;	// passa as normais de entrada para a estrutura
				return o;			// retorna a estrutura
			}
			
			// fragment shader
			float4 frag(v2f i) : COLOR
			{
				float4 c = tex2D(_BaseAlbedo, i.uv);	// guarda valor da cor na imagem de acordo com uvs
				
				// definiçao sobre avaliaçao ternaira para a determinaçao do valor de cor de acordo com toggles
				half4 res = c *(_NormXPlus ? i.normal.x : 
								_NormalXMinus ? -i.normal.x : 
								_NormalYPlus ? i.normal.y :
								 1);
				
				// inverte o valor de cada componente segundo o valor do toggle de inversao
				res = _InvertColor ? 1-res : res; 
				
				// condiçao que determina se o fragmento é discartado ou nao
				// caso todas as componentes sejam maiores que 0.5 discatar
				if(res.x > _ClipValue && res.y > _ClipValue && res.z > _ClipValue )
				{clip(-1);}
				
				// retorna a cor
				return c;
			}
			ENDCG
		}
		
		Pass
        {          
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
      
            #include "UnityCG.cginc"
			
			// estrutura de entrada
            struct appdata
            {
                float4 vertex : POSITION;	// posiçao dos vertices de entradda
            };
		
			// estrutura transitoria, vertex to frag
            struct v2f
            {
                float4 vertex : SV_POSITION;	// posiçao dos vertices transformado
            };

			// vertex shader	
            v2f vert (appdata v)
            {
				// definiçao da estrutura de saida
                v2f o;
				// incrementaçao ao valor da posiçao de x o valor do seno de time/8
				v.vertex.x +=  _SinTime.x;
				// transformaçao das posiçoes locais para clip
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
			// fragment
            fixed4 frag (v2f i) : SV_Target
            {
				// atribuiçao da cor a este novo fragmento
                half4 col = half4(0.2,0.3,0.5,1);

				// caso o valor absoluto do sinTime.a seja superior a 0.1
				if(abs(_SinTime.a) > 0.1){
					clip(-1);	// o fragmento é ignorado
				}
                // retorna a cor do fragmento
				return col;
            }
            ENDCG
        } 
	}
}
