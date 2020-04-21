Shader "Aulas/MyTessalation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}       // imagem de entrada
        _TessRValue("Quantidade de tess", Range(0,64)) = 1   // valore de tesselation
        _TessMap("MapadeTess", 2D) = "white" {}     // imagem para a tesselation
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            // vertex e tesselation vertex pragmas
            //#pragma vertex vert
            #pragma vertex tesselationVert
            // fragment shader
            #pragma fragment frag

            // tesseraltion pragmas
            #pragma hull hullProgram
            #pragma domain DomainProgram

            // shader target
            #pragma target 4.6

            #include "UnityCG.cginc"
            // estrutura de entrada

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            // estrutura vertex to fragmet
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            // pontos de controlo para os valores reais dos vertices
            struct ControlPoint
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                
            };
            // estrutura para o 
            struct TessalationFactor
            {
                float edge[3]   : SV_TESSFACTOR;
                float inside    : SV_INSIDETESSFACTOR;
            };


            // variaveis declaradas
            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed _TessRValue;  // valor da tesselation
            sampler2D _TessMap; // textura da tesselation
            float4 _TessMap_ST;

            // vertex shader
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            // funçao que guarda os valores dos vertices e uvs numa estrutura interna
            ControlPoint tesselationVert(appdata v)
            {
                ControlPoint p;
                p.vertex = v.vertex;
                p.uv = v.uv;
                // retorna a estrutura
                return p;
            }
            
            TessalationFactor PatchConstantFunction(InputPatch<ControlPoint, 3> patch)
            {
                TessalationFactor f;

                f.edge[0] = _TessRValue* tex2Dlod(_TessMap, float4(patch[0].uv.y,0,0,0)).b;
                f.edge[1] = _TessRValue* tex2Dlod(_TessMap, float4(patch[1].uv.y,0,0,0)).b;
                f.edge[2] = _TessRValue* tex2Dlod(_TessMap, float4(patch[2].uv.y,0,0,0)).b;

                f.inside = _TessRValue;

                return f;
            }


            // cabeçalhos para a definiçao do hull para a tesselation
            [UNITY_domain("tri")]
            [UNITY_outputcontrolpoints(3)]
            [UNITY_outputtopology("triangle_cw")]
            [UNITY_partitioning("integer")]
            [UNITY_patchconstantfunc("PatchConstantFunction")]
            ControlPoint hullProgram(InputPatch<ControlPoint, 3> patch, uint id : SV_OUTPUTCONTROLPOINTID)
            {
               return patch[id];
            }


            [UNITY_domain("tri")]
            v2f DomainProgram(TessalationFactor factor, OutputPatch<ControlPoint, 3> patch,float3 barycentriCoord : SV_DOMAINLOCATION)
            {
                appdata data;

                data.vertex = patch[0].vertex * barycentriCoord.x +
                                patch[1].vertex * barycentriCoord.y +
                                patch[2].vertex * barycentriCoord.z;

                data.uv = patch[0].uv * barycentriCoord.x +
                            patch[1].uv * barycentriCoord.y +
                            patch[2].uv * barycentriCoord.z;

                return vert(data);
            }

            // fragment shader
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
