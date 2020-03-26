Shader "Aulas/ShaderLupa"
{
    Properties
    {
        _BaseColor("Color" , Color) = (1,1,1,1) // cor base
        _RazaoMag("Magnificaçao", Range(1,10)) = 1 // valor da magnificaçao
        _AmountRim("quantidade",Float) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent+5" }
        LOD 100
        GrabPass{}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;   // posiçao dos vertices
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 uv : TEXCOORD1;  // uv para o grabPass
                float4 vertex : SV_POSITION;    // posiçao apos projecçao
                float3 normal : NORMAL0;
                fixed3 viewDir : TEXCOORD0;
            };

            sampler2D _GrabTexture; // grab texture

            fixed4 _BaseColor;  // cor base
            fixed _RazaoMag;            

            half _AmountRim;

            v2f vert (appdata v)
            {
                v2f o;
                // projecçao dos vertices para posiçao de clip
                o.vertex = UnityObjectToClipPos(v.vertex);
                // coordenada do centro da textura no GrabPass  
                float4 mid_val = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0,0,0,1)));
                // vector entre o centro da grabText e a posiçao do vertices
                float4  centerToVert = ComputeGrabScreenPos(o.vertex) - mid_val;
                // aplica a Magnificaçao    
                centerToVert /= _RazaoMag;
                // adiciona ao valor central a translaçao resultante
                o.uv = mid_val + centerToVert;
                o.normal = v.normal;
                o.viewDir = ObjSpaceViewDir(v.vertex);                
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET
            {
                // projecta a grabTexture com base na projecçao das uvs
                fixed4 grabColor = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv));
                
                half outline = saturate(dot(normalize(i.normal), normalize(i.viewDir))) - _AmountRim;
                return grabColor * _BaseColor * outline;
            }
            ENDCG
        }
    }
}
