Shader "Unlit/MatrixRotationShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RotationAngle("Angulo de rotaçao", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
        
            fixed _RotationAngle;

            // rotaçao matricial 
            float2 rotateMatrix(float2 position, half angle)
            {
                half c = cos(angle);
                half s = sin(angle);
                return mul(float2x2(c,-s,s,c) , position);  
            }    
    

            // vertex
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = rotateMatrix(TRANSFORM_TEX(v.uv, _MainTex),_SinTime.a * _RotationAngle);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                clip(col == 0 ? -1 : 1);
                return col;
            }
            ENDCG
        }
    }
}
