Shader "Test/Kuwahara distortion"
{
    Properties
    {
        [HideInInspector] _MainTex ("Texture", 2D) = "white" {}
        _Size("Brush Size", Int) = 0
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

            sampler2D _MainTex;         // textura de entrada
            float4 _MainTex_TexelSize;  // tamanho do texel
            int _Size;                  // tamanho do pincel

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half2 uv = i.uv;
 
                float3 mean[4] = {
                    {0, 0, 0},
                    {0, 0, 0},
                    {0, 0, 0},
                    {0, 0, 0}
                };
 
                float3 sigma[4] = {
                    {0, 0, 0},
                    {0, 0, 0},
                    {0, 0, 0},
                    {0, 0, 0}
                };
 
                float2 start[4] = {{-_Size, -_Size}, {-_Size, 0}, {0, -_Size}, {0, 0}};
 
                float2 pos;
                float3 col;
                for (int k = 0; k < 4; k++) {
                    for(int i = 0; i <= _Size; i++) {
                        for(int j = 0; j <= _Size; j++) {
                            pos = float2(i, j) + start[k];
                            col = tex2Dlod(_MainTex, float4(uv + float2(pos.x * _MainTex_TexelSize.x, pos.y * _MainTex_TexelSize.y), 0., 0.)).rgb;
                            mean[k] += col;
                            sigma[k] += col * col;
                        }
                    }
                }
 
                float sigma2;
 
                float n = pow(_Size + 1, 2);
                float4 color = tex2D(_MainTex, uv);
                float min = 1;
 
                for (int l = 0; l < 4; l++) {
                    mean[l] /= n;
                    sigma[l] = abs(sigma[l] / n - mean[l] * mean[l]);
                    sigma2 = sigma[l].r + sigma[l].g + sigma[l].b;
 
                    if (sigma2 < min) {
                        min = sigma2;
                        color.rgb = mean[l].rgb;
                    }
                }
                return color;
            }
            ENDCG
        }
    }
}
