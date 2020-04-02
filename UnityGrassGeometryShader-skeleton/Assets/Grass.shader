Shader "Roystan/Grass"
{
    Properties
    {
		[Header(Shading)]
        _TopColor("Top Color", Color) = (1,1,1,1)
		_BottomColor("Bottom Color", Color) = (1,1,1,1)
		_TranslucentGain("Translucent Gain", Range(0,1)) = 0.5

		[Header(GrassProps)]
		_Largura("largura", Range(0.1,1)) = 1	// largura da relva
		_Altura("Altura", Range(0.5,2)) = 1		// altura da relva
    }

	CGINCLUDE
	#include "UnityCG.cginc"
	#include "Autolight.cginc"

	// Simple noise function, sourced from http://answers.unity.com/answers/624136/view.html
	// Extended discussion on this function can be found at the following link:
	// https://forum.unity.com/threads/am-i-over-complicating-this-random-function.454887/#post-2949326
	// Returns a number in the 0...1 range.
	float rand(float3 co)
	{
		return frac(sin(dot(co.xyz, float3(12.9898, 78.233, 53.539))) * 43758.5453);
	}

	// Construct a rotation matrix that rotates around the provided axis, sourced from:
	// https://gist.github.com/keijiro/ee439d5e7388f3aafc5296005c8c3f33
	float3x3 AngleAxis3x3(float angle, float3 axis)
	{
		float c, s;
		sincos(angle, s, c);

		float t = 1 - c;
		float x = axis.x;
		float y = axis.y;
		float z = axis.z;

		return float3x3(
			t * x * x + c, t * x * y - s * z, t * x * z + s * y,
			t * x * y + s * z, t * y * y + c, t * y * z - s * x,
			t * x * z - s * y, t * y * z + s * x, t * z * z + c
			);
	}

	ENDCG

    SubShader
    {
		Cull Off

        Pass
        {
			Tags
			{
				"RenderType" = "Opaque"
				"LightMode" = "ForwardBase"
			}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma target 4.6
			#pragma geometry geo
	
            
			#include "Lighting.cginc"

			float4 _TopColor;
			float4 _BottomColor;
			float _TranslucentGain;

			half _Largura;	// largura da relva
			half _Altura;	// altura da relva
			// input da applicaçao
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};
			// estrutura de saida entre vertex e geometric
			struct v2g
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};
			
			// estrutura de saida para o frag
			struct geometryOutput{
				float4 pos : SV_POSITION;
				float2 c : TEXCOORD0;
			};
			
			v2g vert(appdata v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.normal = v.normal;
				o.tangent = v.tangent;
				return o;
			}

			// Add to the CGINCLUDE block.
			geometryOutput VertexOutput(float3 pos, float2 cor)
			{
				geometryOutput o;
				o.pos = UnityObjectToClipPos(pos);
				o.c = cor;
				return o;
			}


			[maxvertexcount(3)]
			void geo(triangle v2g IN[3] : SV_POSITION, inout TriangleStream<geometryOutput> triStream)
			{
				// Place in the geometry shader, below the line declaring float3 pos.		
				float3 vNormal = IN[0].normal;
				float4 vTangent = IN[0].tangent;
				float3 vBinormal = cross(vNormal, vTangent) * vTangent.w;

				float4 pos = IN[0].vertex;
				
				// Add below the lines declaring the three vectors.
				float3x3 tangentToLocal = float3x3(
					vTangent.x, vBinormal.x, vNormal.x,
					vTangent.y, vBinormal.y, vNormal.y,
					vTangent.z, vBinormal.z, vNormal.z
					);



				// ...and replace it with the code below.
				pos.xz -= 0.5;
				triStream.Append(VertexOutput(pos + mul(tangentToLocal, float3(_Largura, 0, 0)),float2(0,0)));
				triStream.Append(VertexOutput(pos + mul(tangentToLocal,float3(-_Largura, 0, 0)), float2(0,0)));
				triStream.Append(VertexOutput(pos + mul(tangentToLocal,float3(0, 0, _Altura)),float2(1,1)));
			}
			float4 frag (geometryOutput geoin, fixed facing : VFACE) : SV_Target
            {	
				return lerp(_BottomColor,_TopColor, geoin.c.y);
            }
            ENDCG
        }
    }
}