// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Aulas/RayMarchingIntro"
{
    // ray march, introduçao 
    Properties
    {
        _SphereRadius("Raio", Range(0.1,2)) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "unityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;   // necessário apenas a posiçao dos vertices
            };

            struct v2f
            {
                float3 wPos : TEXCOORD0;
                float4 pos  : SV_POSITION;

                float3 originPosition : TEXCOORD1;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);             // Posiçoes de clips
                o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;    // posiçoes no mundo
                o.originPosition = mul(unity_ObjectToWorld, float4(0,0,0,1));
            
                return o;
            }

            #define STEPS 128
            #define STEP_SIZE 0.02

            // variaveis internas
            fixed _SphereRadius;

            bool SphereHit(float3 p, float3 center, float radius)
            { return (distance(p, center)< radius); }

            // marching hit
            float3 RayMarchHit(float3 position,float3 center, float3 direction)
            {
                for(int i = 0 ; i < STEPS; i++)
                {   
                    if( SphereHit(position, center , _SphereRadius))
                    return normalize(mul(unity_WorldToObject, position));      

                    // incrementa a posiçao de step
                    position += direction * STEP_SIZE;
                }    
                                
                return float3(0,0,0);   // caso nao tenha obtido nenhuma colisao
            }


            fixed4 frag (v2f i) : SV_Target
            {
                float3 viewDir = normalize(i.wPos - _WorldSpaceCameraPos);
                float3 worldPos = i.wPos;

                float3 depthOfPixel = RayMarchHit(worldPos,i.originPosition,viewDir);

                if(length(depthOfPixel) != 0)
                {
                    half nl = clamp(dot(normalize(worldPos - i.originPosition), _WorldSpaceLightPos0.xyz),0,1);
                    float4 diff = nl * _LightColor0;
                    return fixed4(depthOfPixel* diff.xyz ,1) ;
                }
                else
                {
                    return fixed4(1,1,1,0);
                }
            }
            ENDCG
        }
    }
}
