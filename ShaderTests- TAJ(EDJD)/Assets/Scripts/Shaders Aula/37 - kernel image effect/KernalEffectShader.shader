Shader "Hidden/KernalEffectShader"
{
    Properties
    {
        [HideInInspector] _MainTex ("Texture", 2D) = "white" {}
        
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            fixed _Amount;
            

            fixed4 KernelEffect(float2 uv)
            {
                float4 res = float4(0,0,0,0);
        
                // definiçao da matriz de kernel
                float3x3 mtrx = (1,2,1,
                                 2,8,2,
                                 1,2,1);
                mtrx /= 16;
                
                for(float x  = -1; x <= 1 ; x++)
                    for(float y = -1; y <= 1; y++)
                    {
                        res += tex2D(_MainTex, uv+ float2(x*_MainTex_TexelSize.x, y * _MainTex_TexelSize.y)) * mtrx[x][y];
                    }
                
                return res;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);


                
                // just invert the colors
                return KernelEffect(i.uv);
                //return col;
            }
            ENDCG
        }
    }
}
