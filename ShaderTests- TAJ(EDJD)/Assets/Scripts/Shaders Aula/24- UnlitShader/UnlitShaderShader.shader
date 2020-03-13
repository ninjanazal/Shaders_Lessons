Shader "Aulas/MyFristVertFragshader"
{

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            // estrutura de entrada
            struct appdata
            {
                float4 vertex : POSITION;
            };

            // estrutura de transiçao
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;

            };

            // vertex shader
            v2f vert (appdata v)
            {
                // inicia a estrutura de transiçao
                v2f o;
                // converte a posiçao dos vertices de entrada na posiçao de camera
                o.vertex = UnityObjectToClipPos(v.vertex);
                // guarda no valor de r a posiçao de x na 
                o.color.r = v.vertex.x;
                o.color.g = v.vertex.z;

                return o;
            }

            // fragment shader
            fixed4 frag (v2f i) : SV_Target
            {           
                // inicia a cor de saida
                fixed4 col;     
                // guarda no valor de saida a cor do anteriormente definida
                col = i.color;
                col.r = i.vertex.r;          
                // retorna um float4 pelo facto de ser uma cor
                return col;
            }
            ENDCG
        }
    }
} 