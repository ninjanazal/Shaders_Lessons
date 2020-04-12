Shader "Analise/ShaderAnalise"
{
   // shader numero 1 para Analise

    	Properties
	{
		_Sura ("sura", 2D) = "white" {}
		_Sura2 ("sura", 2D) = "white" {}

		[Toggle]
		_A("A", Range(0,1)) = 1
		[Toggle]
		_B("B", Range(0,1)) = 1
		[Toggle]
		_C("C", Range(0,1)) = 1

		[Toggle]
		_D("D", Range(0,1)) = 1

	}

	SubShader
	{	
	
		Cull Off
		Tags { "RenderType"="Opaque" }

	
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
	}
}
