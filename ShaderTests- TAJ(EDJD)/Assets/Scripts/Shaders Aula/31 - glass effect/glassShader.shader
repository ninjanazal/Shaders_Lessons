Shader "Aulas/glassShader"
{
     Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap("normal map", 2D) =  "bump" {}
        _ScaleUV("escala de uvs", Range(1,20)) = 1
    }
    SubShader
    {
        Cull Back
        Tags{ "Queue" = "Transparent"}
        GrabPass{}
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
                float2 uv : TEXCOORD0; // uv da textura
                float4 uvGrab : TEXCOORD1;  // uvs para o grab
                float2 uvBump : TEXCOORD2;  // uvs para o bump
                
                float4 vertex : SV_POSITION;
            };

            sampler2D _GrabTexture; // grab texture
            float4 _GrabTexture_TexelSize;
    
            sampler2D _MainTex; // main text
            float4 _MainTex_ST; // s

            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            fixed _ScaleUV;

            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //o.uvGrab.xy = (float2(o.vertex.x , -o.vertex.y) + o.vertex.w) * 0.5;
                //o.uvGrab.zw = o.vertex.zw;
    
                o.uvGrab = ComputeScreenPos(o.vertex);
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvBump = TRANSFORM_TEX(v.uv, _BumpMap);
                
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                // valor de distorçao do bump 
                half2 bumpValue = UnpackNormal(tex2D(_BumpMap,i.uvBump)).rg;

                //_GrabTexture_TexelSize.y = _GrabTexture_TexelSize <0 ? 1- _GrabTexture_TexelSize.y : _GrabTexture_TexelSize.y;

                float2 offset = bumpValue * _ScaleUV;          

                i.uvGrab.xy = offset * i.uvGrab.z + i.uvGrab.xy;

                fixed4 baseGrab = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvGrab));
                fixed4 baseMain = tex2D(_MainTex, i.uv);
                
                return baseGrab * baseMain;
            }
            ENDCG
        }
    }
}
