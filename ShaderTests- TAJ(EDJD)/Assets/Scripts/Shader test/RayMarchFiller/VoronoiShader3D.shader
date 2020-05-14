Shader "Aulas/VoronoiShader3D"
{
    Properties
    {
        _BaseColor("Cor",Color) = (1,1,1,1)
        _AngleOff("Angle offset", Float) = 1
        _CellDensity("Densidade", Float) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent+4" }
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
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            // variaveis
            fixed4 _BaseColor;
            fixed _AngleOff, _CellDensity;

            // random value
            float random (float2 st) { return frac(sin(dot(st.xy, float2(12.9898,78.233)))* 43758.5453123);}

            float3 voronoiNoise(float3 value)
            {   
			    float3 baseCell = floor(value);

			    //first pass to find the closest cell
			    float minDistToCell = 10;
			    float3 toClosestCell;
			    float3 closestCell;

			    for(int x1=-1; x1<=1; x1++)
                {
				    for(int y1=-1; y1<=1; y1++)
                    {
					    for(int z1=-1; z1<=1; z1++)
                        {
						    float3 cell = baseCell + float3(x1, y1, z1);
						    float3 cellPosition = cell + random(cell);
						    float3 toCell = cellPosition - value;
						    float distToCell = length(toCell);
						    if(distToCell < minDistToCell)
                            {
							    minDistToCell = distToCell;
							    closestCell = cell;
							    toClosestCell = toCell;
						    }
					    }
				    }
			    }

			    //second pass to find the distance to the closest edge
			    float minEdgeDistance = 10;

			    for(int x2=-1; x2<=1; x2++)
                {
				    for(int y2=-1; y2<=1; y2++)
                    {
					    for(int z2=-1; z2<=1; z2++)
                        {
						    float3 cell = baseCell + float3(x2, y2, z2);
						    float3 cellPosition = cell + random(cell);
						    float3 toCell = cellPosition - value;

						    float3 diffToClosestCell = abs(closestCell - cell);
						    bool isClosestCell = diffToClosestCell.x + diffToClosestCell.y + diffToClosestCell.z < 0.1;
						    if(!isClosestCell)
                            {
							    float3 toCenter = (toClosestCell + toCell) * 0.5;
							    float3 cellDifference = normalize(toCell - toClosestCell);
							    float edgeDistance = dot(toCenter, cellDifference);
							    minEdgeDistance = min(minEdgeDistance, edgeDistance);
						    }
					    }
				    }
			    }
                float randomVal = random(closestCell.xy);
    		    return float3(minDistToCell, randomVal, minEdgeDistance);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _BaseColor;
                float3 voronoiDisplace = voronoiNoise(2.0f);
                
                return  voronoiDisplace.z;
            }
            ENDCG
        }
    }
}
