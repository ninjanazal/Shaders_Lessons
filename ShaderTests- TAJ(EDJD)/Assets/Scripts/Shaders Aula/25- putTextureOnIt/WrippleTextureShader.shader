Shader "Aulas/FragVertTextureShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}   // textura de entrada
        _SliderX("scale x",Range(1,10)) = 1 // slider sobre o valor de x
        _SliderY("scale y", Range(1,10)) = 1    // slider sobre o valor de y
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Opaque" }

        // 
        GrabPass{}
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
                float2 uv : TEXCOORD0;
            };

            // estrutura de transiçao
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // decleraçao de variaveis internas
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _SliderX;     // declaraçao de valor float passado pelo slide
            float _SliderY; // declaraçao de valor float passado pelo slider y

            sampler2D _GrabTexture; // textura retornada pelo grabpass

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // transfoma a textura de entrada relativa aos uvs do objecto
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //o.vertex.x = sin(o.vertex.x * _SliderX);
                o.uv.x = sin(o.uv.x * _SliderX);
                o.uv.y = sin(o.uv.y * _SliderY);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // atribui á cor a textura de entrada
                fixed4 col = tex2D(_GrabTexture, i.uv);                
                return col;
            }
            ENDCG
        }
    }
}
