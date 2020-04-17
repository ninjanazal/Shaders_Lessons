Shader "Analise/ShaderAnalisePass"
{
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
			#pragma vertex ara
			#pragma fragment oro
			
			#include "UnityCG.cginc"

			struct a
			{
				float4 p : POSITION;
				float3 n : NORMAL;
				float2 u : TEXCOORD0;
			};

			struct b
			{
				float4 p : SV_POSITION;
				float2 n : NORMAL;
				float2 u : TEXCOORD0;
			};

			sampler2D _Sura;
			sampler2D _Sura2;
	

			float _A;
			float _B;
			float _C;
			float _D;

			b ara (a i)
			{
				b o;
				o.p = UnityObjectToClipPos(i.p);
				o.u = i.u;
				o.n = i.n;
				return o;
			}
			
			float4 oro(b i) : COLOR
			{
				float4 c = tex2D(_Sura, i.u);
				float4 d = tex2D(_Sura2, i.u);

				c =		_A == 1 ? c*  i.n.x : 
						_B == 1 ? c*  -i.n.x : 
						_C == 1 ? c*  i.n.y : 
						c;


				c.x = _D == 1 ? 1-c.x : c.x; 
				c.y = _D == 1 ? 1-c.y : c.y; 
				c.z = _D == 1 ? 1-c.z : c.z; 

				if(c.x > 0.5 && c.y > 0.5 && c.z > 0.5 )
				{
					clip(-1);
				}
				else
				{
					c = tex2D(_Sura, i.u);
				}
				
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : Normal;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

      

            v2f vert (appdata v)
            {
                v2f o;
			
				v.vertex.x +=  _SinTime.x;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                half4 col = half4(0.2,0.3,0.5,1);

				 
				if(abs(_SinTime.a) > 0.1){
					clip(-1);
				}
                
				return col;
            }
            ENDCG
        } 
	}
}
