Shader "Unlit/VolumetricMarch"
{
    Properties
    {
        _FogCenter("Valores de entrada para o fog... xyz, pos, z radius", Vector) = (0,0,0,1)   // pos e radius
        _FogColor("Cor da fog", Color) = (1,1,1,1)                                              // cor do nevoeiro
        _InnerRatio("Thickness of fog", Range(0,1)) = 0.5                                     // densidade do centro
        _Density("Densidade do nevoeiro", Range(0,1)) = 0.5
        _Segment("Segmentos", Int) = 10
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Cull off Lighting off ZWrite off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
           
            struct v2f
            {
                float3 view : TEXCOORD0;        // posiçao de vista
                float4 pos : SV_POSITION;       // posiçao dos vertices
                float4 posProj : TEXCOORD1;     // vertices projectados
            };
            sampler2D _CameraDepthTexture;
            float4 _FogCenter;  // var que guarda o centro do nevoeiro e o raio de influencia
            fixed4 _FogColor;   // cor do nevoeiro
            half _InnerRatio, _Density;   // densidade do centro
            int _Segment;


            // calcular a intensiade do nevoeiro
            float CallCulateFogIntensity(float3 sphereCenter, float sphereRadius, float innerRadius, float sphereDensity,
                float cameraPos, float3 viewDir, float maxDistance)
            {
                // calcular a intersecçao
                float3 localCam = cameraPos - sphereCenter;
                
                float a = dot(viewDir,viewDir); // dot product sobre ele proprio, retorna o vetor ao quadrado
                float b = 2 * dot(viewDir, localCam);
                float c = dot(localCam, localCam) - pow(sphereRadius, 2);

                float d = b*b - (4*a*c);  // calculo do descriminante
    
                // caso nao exista soluçoes, nao ocorre uma iterceçao
                if(d <= 0)
                    return 0;
                // existindo calculando os pontos de interceçao
                float Dsqrt = sqrt(d);
                float dist = max(((-b) - Dsqrt )/ 2 * a, 0);
                float dist2 = max(((-b) + Dsqrt )/ 2 * a, 0);

                float backDepth = min(maxDistance, dist2);
                float sampl = dist;

                // start marcking step
                float step_distance = (backDepth - dist) / _Segment;
                float step_contribution = sphereDensity;

                float centerValue = 1 / (1- innerRadius);
                float clarity = 1;

                for(int seg = 0; seg < _Segment ; seg++)
                {
                    float3 position = localCam + viewDir * sampl;
                    float val = saturate(centerValue * (1 - length(position / sphereRadius)));
                    float fog_amount = saturate(val * step_contribution);
                    
                    clarity *= 1 - fog_amount;
                    sampl += step_distance;
                }

                return 1 - clarity;
    
            }

            v2f vert (appdata_base v)
            {
                v2f o;
                float4 wPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);      
                o.view = wPos - _WorldSpaceCameraPos;
                //o.view = WorldSpaceViewDir(v.vertex);
                o.posProj = ComputeScreenPos(o.pos);
    
                float inFrontof = (o.pos.z / o.pos.w) > 0;
                o.pos.z *= inFrontof;
                return o;
            }

            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(1,1,1,1);

                float depth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.posProj))));

                float3 viewdirection = normalize(i.view);
                float fogD = CallCulateFogIntensity( _FogCenter.xyz, _FogCenter.w, _InnerRatio, _Density, _WorldSpaceCameraPos, viewdirection,depth);
            

                col.xyz = _FogColor.xyz;
                col.a = fogD;
                return col;
            }
            ENDCG
        }
    }
}
