Shader "Aulas/ClipEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("Main Color",Color) = (0,0,0,0)
        _ToTexture("Second Texture", 2D) = "white"{}

        _ClipSlider("Clip fact", Range(0,1.1)) = 1.1
        _MaxDistance("Max distance", Range(0,5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Back


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag Lambart

            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // vertex to frag
            struct v2f
            {
                float2 uv : TEXCOORD0;      
                float2 uv2 : TEXCOORD1;     // uvs para a segunda              
                float4 vertex : SV_POSITION;

                float4 screenPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            sampler2D _ToTexture;

            float4 _MainTex_ST;
            float4 _ToTexture_ST;

            float4 _MainColor;  // cor base

            float _ClipSlider;      // clip da textura
            float _MaxDistance;     // distancia maxima para clip

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = TRANSFORM_TEX(v.uv,_ToTexture);

                o.screenPos = ComputeScreenPos(o.vertex);   // valor do vert para screen pos
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                
                fixed4 col = tex2D(_MainTex, i.uv) * _MainColor;
                if(col.x < _ClipSlider)
                {col = tex2D(_ToTexture,i.uv2) * _MainColor;}
                
                clip( (i.screenPos.w < _MaxDistance)? -1 :(col-0.01) - _SinTime.w );

                return col;
            }
            ENDCG
        }
    }
}
