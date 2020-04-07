Shader "Unlit/cod3-2020"
{
	Properties {
      _Tint("Colour Tint", Color) = (1,1,1,1)
      _Sd("Speed", Range(1,100)) = 10
      _S1("Scale 1", Range(0.1,10)) = 2
	  _Sura ("sura", 2D) = "white" {}
 
    }
	SubShader
	{

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 v : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 v : SV_POSITION;
				float4 vertexColor: COLOR0;
			};

			float4 _Tint;
		    float _S;
		    float _S1;
		  sampler2D _Sura;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.v = UnityObjectToClipPos(v.v);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col;


				const float PI = 3.14159265;
	            float t = _Time.x * _S;

	            float xpos = i.v.x * 0.001;
	            float ypos = i.v.y * 0.001;
	          
	    


	            float c = sin(xpos * _S1 + t);


	    
	            c += sin((xpos*sin(t/2.0) + ypos*cos(t/3))+t);

	

	            col.r = sin(c/4.0*PI);
	            col.g = sin(c/4.0*PI + 2*PI/4);
	            col.b = sin(c/4.0*PI + 4*PI/4);
				col.a = 1;

				col *= _Tint;
				
				if(col.r > 5 && sin(t) > 0.5){
				clip(-1);
				}

				return col;
			}
			ENDCG
		}
	}
}