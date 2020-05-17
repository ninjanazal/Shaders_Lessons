Shader "Unlit/LastShader"
{
    Properties
    {
    [Toggle] _m("Toogle de rotaçao", Float) = 0         // activa / desativa a rotaçao do volume
    [Toggle] _j("Toogle de espelhamento", Float) = 0    // activa / desativa o espelhamento do volume

        
    }
      SubShader
    {
        Tags { "Queue"="Transparent" }      // ordem de transparencia
        Blend SrcAlpha OneMinusSrcAlpha     // blend normal
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            // entrada
            struct appdata  
            {
                float4 vertex : POSITION;       // posiçao dos vertices, obj
            };
            // vertex to frag
            struct v2f
            {
              float3 hades :TEXCOORD0;          // posiçao do vertice no mundo
              float4 pos :SV_POSITION;          // posiçao dos vertices em clip
              float4 zeus :TEXCOORD1;           // posiçao do centro no mundo
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _m;   // toggle de rotaçao
            float _j;   // toggle de espelhamento

            v2f vert (appdata v)
            {
                v2f o;
                // transformaçao de posiçao de obj para posiçao de clip
                o.pos = UnityObjectToClipPos(v.vertex);
                // posiçao no mundo dos vertices do objecto
                o.hades = mul(unity_ObjectToWorld, v.vertex).xyz;
                // posiçao no mundo do centro do obj
                o.zeus = mul(unity_ObjectToWorld, float4(0.0,0.0,0.0,1.0));

                return o;
            }

            // valores defenido de set
            #define SUN 200
            // valor definido para o tamanho de step
            #define MOON 0.01
           
            
            // definiçao para colisao com um esfera, retorna positivo quando o step encontra-se dentro da esfera
            // p -> posiçao do step
            // c -> posiçao da esfera
            // r-> raio da esfera
            bool SH(float3 p, float3 c, float r){ return distance(p, c) < r; }


            // funçao para obter um valor pseudo Random
            float Ra (float2 st) { return frac(sin(dot(st.xy, float2(12.9898,78.233)))* 43758.5453123);}

            // funçao de rotaçao de um vector p dado o angulo, sobre o eixo dos x
            float3 Seth(float3 p, float angle){
                float c = cos(angle);   // determina o cos do angulo
                float s = sin(angle);   // determina o sen do angulo
                
                // retorna o vector multiplicado pela matriz de rotaçao em x
                return mul(float3x3( 1, 0, 0,
                                     0, c, -s,
                                     0, s, c), p);
            }

            
            // nucle de march, recebe 
            // poney -> posiçao no mundo do fragment
            // medusa -> posiçao do centro no mundo, pode ser manipulada quando o Toggle de rotaçao estiver activo
            // direction -> indica direcçao de march, determinada, posiçao do frag no mundo - pos cam no mundo
            float3 FuncaoMagic(float3 poney, float3 medusa ,float3 direction)
            {
                // ciclo que decorre de acordo com a quantidade de passos definidos
                for(int i = 0 ; i < SUN; i++)
                {                  
                    // avalia se o fragmento a ser determinado está dentro do volume de uma esfera de raio 0.5 e
                    // se o produto escalar entre o vector da posiçao no mundo e    
                    if(SH(poney, medusa, 0.5) && (dot(normalize(poney),normalize(medusa)) > 0.95  ) 
                            // esta condiçao resulta num pequenissimo pixel mostrado, questionavel e removivel para reduçao de validaçoes
                            || SH(poney, medusa, 0.5) &&  (dot(normalize(poney),normalize(medusa)) == 0.1)) 
                            return poney;
                    // se o toogle de espelhamento estiver actido
                    if(_j)
                    {     
                        // confirma tambem para o valor negativo do produto escalar entre os mesmos, resultado num espelhamento, dentro da
                        // area da esfera, a terceira condiçao apresenta os problemas que a anterior mostrava
                        if(SH(poney, medusa, 0.5) && (-dot(normalize(poney),normalize(medusa)) > 0.95  ) 
                            || SH(poney, medusa, 0.5) &&  (dot(normalize(poney),normalize(medusa)) == 0.1  ) )
                                return poney;
                    }                
                    // caso nao tenha passado a nenhuma das condiçoes, continua a marcha
                    // adidiconao á posiçao actual, a direcçao multiplicado pelo tamanho de step
                    poney += direction * MOON;
                 }
                // caso nao resulte nenhuma, o ray nao atingiu nenhum volume, como tal é retornado um vector 000
                return float3(0,0,0);
            }

     

            fixed4 frag (v2f i) : SV_Target
            {
                // direcçao de vista relativo ao fragmento
                float3 viewDire = normalize(i.hades - _WorldSpaceCameraPos);
                // posiçao do fragmento no mundo
                float3 worldPos = i.hades;
            
                // guarda o valor transformado atravez da funçao, este vector representa uma rotaçao sobre x , dependendo do valor do tempo
                float3 SethInfluence = Seth(i.zeus,_Time.a);
                  
                // variavel para guardar valor retornado pela funçao de marck
                float3 depthOfPixel;
                // caso o toggle de rotaçao esteja activo
                if(_m)
                    // calcula a distancia do pixel em relaçao á camera, utilizando a posiçao rodada sobre o eixo dos x
                    depthOfPixel =  FuncaoMagic(worldPos, SethInfluence ,viewDire);
                else
                    // caso nao esteja activo, determina a distancia do volume com o centro do objecto
                    depthOfPixel =  FuncaoMagic(worldPos, i.zeus ,viewDire);

                // guarda a distancia entre a posiçao no mundo do objecto e a posiçao da camera
                float afrodite = distance(i.zeus, _WorldSpaceCameraPos);
                   
                // caso o fragmento do volume esteja a um valor >0 de distancia, representado pelo cumprimento do vector 
                if(length(depthOfPixel))
                {
                    // determina a cor a dar ao fragmento do volume
                    return fixed4(depthOfPixel.x + 1/afrodite,  // valor em x da profundidade do pixel mais o inverso da distancia 
                                  depthOfPixel.y + 1/afrodite, 
                                  1, 
                                  1*Ra(depthOfPixel.x)) ;       
                } else {
                    // caso seja < 0 ignora o fragmento
                    clip(-1);
                    return 0;
                }
                   
            }
            ENDCG
        }
    }
}
