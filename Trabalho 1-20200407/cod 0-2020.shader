// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/Cod1-2020"
{
    	Properties
	{
		_Sura ("sura", 2D) = "white" {}
		_Sura2 ("sura", 2D) = "white" {}
		_l1("l1", Vector) = (1,1,1,0)
		_l2("l2", Vector) = (-1,-1,-1,0)

		[Toggle]
		_coolElf("collElf", Range(0,1)) = 1
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
			float3 _l1;
			float3 _l2;

			float _coolElf;
			
			float random (float2 uv)
            {
                return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
            }


			b ara (a i)
			{
				b o;
				o.p = UnityObjectToClipPos(i.p);
				o.u = i.u;
				o.n = mul( unity_ObjectToWorld, float4( i.n, 0.0 ) ).xy;
				return o;
			}
			
			float4 oro(b i) : COLOR
			{
				float3 l1 = normalize(_l1);
				float3 l2 = normalize(_l2);
				float2 yav = i.u;
				float4 c = tex2D(_Sura, yav);
				
				if(_coolElf==0)
				{
					if(dot(l1, i.n) > 0.0) 
						{					
							c = tex2D(_Sura, yav);
						}
					if(dot(l2, i.n) > 0.0)
						{
						   clip(-1);
						}
				}
				else 
					{
				
					if(dot(l2, i.n) > sin(random(_Time.a)) && _SinTime.a >0 )		
						{
						   clip(-1);
						}
						else c = tex2D(_Sura, yav);
					}
			
				return c;
			}
			ENDCG
		}
	}
}
