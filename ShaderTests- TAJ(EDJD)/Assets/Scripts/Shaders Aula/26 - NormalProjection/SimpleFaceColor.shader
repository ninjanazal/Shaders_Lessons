Shader "Aulas/SimpleFaceColor"
{
    Properties
    {
        _BaseColor("Cor base",Color) = (1,1,1,1)    // cor base
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  }

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"            

            // decleraçao de vars
            float4 _MainTex_ST;
            fixed4 _BaseColor;  
           
            // estrutura de transiçao
            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR0;
            };
            
            
            v2f vert (appdata_base v)
            {
                v2f o;  // definiçao da estrutura de saida
                
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.normal * 0.5 + 0.5;
                
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half n1 = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));


                o.color *= n1 * _LightColor0;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            { 
                return fixed4 (_BaseColor * i.color , 1);
            }
            ENDCG
        }
    }
}
