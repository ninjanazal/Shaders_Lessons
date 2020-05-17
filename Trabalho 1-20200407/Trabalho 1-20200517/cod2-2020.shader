Shader "Unlit/cod2-2020"
{
	Properties {
      _Tint("CT", Color) = (1,1,1,1)
      _Sd("Sp", Range(1,100)) = 10
	  _Sd2("Sp", Range(1,100)) = 10
      //_S1("Scale 1", Range(0.1,10)) = 2
	  _Sura ("sura", 2D) = "white" {}
	  _Ol ("humm", Range (.002, 1.1)) = .005

	  [Toggle]
		_coolElf("collElf", Range(0,1)) = 1

		_MainTex ("Texture", 2D) = "white" {}
    }
	SubShader
	{

	

	Cull Off
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
				float3 n : NORMAL;
			
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 v : SV_POSITION;

			};

			float4 _Tint;
		    float _Sd;
			float _Sd2;
		    float _S1;
			 sampler2D _Sura;
			fixed _Ol;
			float _coolElf;


			v2f vert (appdata v)
			{
				v2f o;
	
				if(_coolElf ==0){
				v.v.xyz += _Ol * v.n;
				}
				else v.v.xyz += abs(sin(_Time.x * _Sd2))* v.n;
				

				o.v = UnityObjectToClipPos(v.v);
				
			

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				fixed4 col;
		
				
				const float PI = 3.14159265;
	            float t = _Time.x * _Sd;

	            float xpos = i.v.x * 0.001;
	            float ypos = i.v.y * 0.001;
	          
	   

	            float c = sin(xpos * 1 + t);


	    
	            c += sin((xpos*sin(t/2.0) + ypos*cos(t/3))+t);

			

	            col.r = sin(c/4.0*PI);
	            col.g = sin(c/4.0*PI + 2*PI/4);
	            col.b = sin(c/4.0*PI + 4*PI/4);
				col.a = 1;

				col *= _Tint;
				

				return col;
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = tex2D(_MainTex, i.uv);

                return col;
            }
            ENDCG
        } 
	}


       
       
       
    
}