Shader "Unlit/LastShader"
{
    Properties
    {
    [Toggle] _m("m", Float) = 0
    [Toggle] _j("j", Float) = 0

        
    }
      SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
   
            };

            struct v2f
            {
              float3 hades :TEXCOORD0;
              float4 pos :SV_POSITION;
              float4 zeus :TEXCOORD1;
              
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.hades = mul(unity_ObjectToWorld, v.vertex).xyz;
              
                o.zeus = mul(unity_ObjectToWorld, float4(0.0,0.0,0.0,1.0));

                return o;
            }

            #define SUN 200
            #define MOON 0.01
           

            bool SH(float3 p, float3 c, float r){
                return distance(p, c) < r;
            }

            float _m;
            float _j;


            float Ra (float2 st) {
                    return frac(sin(dot(st.xy,
                                         float2(12.9898,78.233)))*
                        43758.5453123);
                }

            float3 Seth(float3 p, float angle){

                float c = cos(angle);
                float s = sin(angle);
    
                return mul(float3x3( 1, 0, 0,
                                     0, c, -s,
                                     0, s, c), p);
            }


            float3 FuncaoMagic(float3 poney, float3 medusa ,float3 direction){
            
                for(int i = 0 ; i < SUN; i++){
                    
                   
                    if(SH(poney, medusa, 0.5) && (dot(normalize(poney),normalize(medusa)) > 0.95  ) 
                            || SH(poney, medusa, 0.5) &&  (dot(normalize(poney),normalize(medusa)) == 0.1  ) )
                            return poney;

                     if(_j)
                     {        
                        if(SH(poney, medusa, 0.5) && (-dot(normalize(poney),normalize(medusa)) > 0.95  ) 
                        || SH(poney, medusa, 0.5) &&  (dot(normalize(poney),normalize(medusa)) == 0.1  ) )
                            return poney;
                      }

              
                
                    poney += direction * MOON;
                   
                }
            

                return float3(0,0,0);
            }

     

            fixed4 frag (v2f i) : SV_Target
            {
            
                   float3 viewDire = normalize(i.hades - _WorldSpaceCameraPos);
                   float3 worldPos = i.hades;

                   float3 SethInfluence = Seth(i.zeus,_Time.a);
                  

                   float3 depthOfPixel;
                   if(_m)
                     depthOfPixel =  FuncaoMagic(worldPos, SethInfluence ,viewDire);
                   else
                    depthOfPixel =  FuncaoMagic(worldPos, i.zeus ,viewDire);


                   float afrodite = distance(i.zeus, _WorldSpaceCameraPos);
                   
                   if(length(depthOfPixel)){

                        return fixed4(depthOfPixel.x + 1/afrodite,
                                      depthOfPixel.y + 1/afrodite, 
                                      1, 
                                      1*Ra(depthOfPixel.x)) ;
                   }else{

                        clip(-1);
                        return 0;
                   }
                   
            }
            ENDCG
        }
    }
}
