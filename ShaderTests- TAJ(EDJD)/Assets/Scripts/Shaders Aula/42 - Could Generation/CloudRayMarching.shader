Shader "Unlit/CloudRayMarching"
{
    Properties
    {
        _Scale("Scale", Range(0.1, 10)) = 2.0
        _SetScale("Step Scale", Range(0.1, 100)) = 1
        _Steps("Steps", Range(1,200)) = 60
        _MinHeight("_MinHeight", Range(0.0, 5)) = 0
        _MaxHeight("_MaxHeight", Range(6, 10)) = 10.0
        _FadeDist("Fade distance", Range(0.0, 10.0)) = 0.5
        _SunDir ("Sun Direction", vector) = (1,0,0,0)
    }

    CGINCLUDE

    // \ indica continuaçao de linha
    // funçao de march
    #define MARCH(steps, noiseMap, cameraPos, viewDir, bgcol, sum, depth, t) \
    { \
        for (int i = 0; i < steps  + 1; i++) \
        { \
            if(t > depth) \
            break; \
            float3 pos = cameraPos + t * viewDir; \
            if (pos.y < _MinHeight || pos.y > _MaxHeight || sum.a > 0.99) \
            {\
                t += max(0.1, 0.02*t); \
                continue; \
            }\
            \
            float density = noiseMap(pos); \
            if (density > 0.01) \
            { \
                float diffuse = clamp((density - noiseMap(pos + 0.3 * _SunDir)) / 0.6, 0.0, 1.0);\
                sum = integrate(sum, diffuse, density, bgcol, t); \
            } \
            t += max(0.1, 0.02 * t); \
        } \
    } 
    
    #define NOISEPROC(N,P)  1.75* N * saturate((_MaxHeight - P.y)/_FadeDist)


    float map1(float q){
        float3 p = q;
        float f; //é acumlação de noise
        f = 0,5 * noise3d(q);

        return NOISEPROC(f,p);
    }



    fixed4 raymarch(float3 cameraPos, float3 viewDir, fixed4 bgcol, float depth)
    {                
        fixed4 col = fixed4(0,0,0,0); //O que vamos retornar
        float ct = 0; //Contador de Steps 


        MARCH(_Steps, map1, cameraPos, viewDir, bgcol, col, depth, ct);

        return clamp(col, 0.0, 1.0);


        return(1,1,1,1);
    }

    ENDCG

    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off Lighting Off ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float3 view : TEXCOORD0;        // posiçao de vista
                float4 pos : SV_POSITION;       // posiçao dos vertices
                float4 posProj : TEXCOORD1;     // vertices projectados
                float3 wPos : TEXCOORD2;        // posiçao no mundo
            };
            
            // propriedades
            float _Scale, _SetScale, _Steps, _MinHeight, _MaxHeight, _FadeDist;
            float4 _SunDir;
            
            sampler2D _CameraDepthTexture;

            v2f vert (appdata v)
            {
                v2f o;
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.view = wPos.xyz - _WorldSpaceCameraPos;
                o.posProj = ComputeScreenPos(o.pos);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float depth = 1;                
                depth *= length(i.view);
                
                fixed4 col = fixed4(1,1,1,0);
                fixed4 clouds = rayMarch(_WorldSpaceCameraPos, normalize(i.view) * _SetScale, col, depth);

                fixed3 mixedCol = col * (1 - coulds.a) + clouds.rgb;
                return fixed4(mixedCol, clouds.a);
            }
            ENDCG
        }
    }
}
